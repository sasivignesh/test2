#include <ortp/ortp.h>
#include <ortp/payloadtype.h>
#include <bzrtp/bzrtp.h>
#include <srtp2/srtp.h>
#include <alsa/asoundlib.h>
#include <pthread.h>
#include <stdio.h>
#include <string.h>

#define ZRTP_PAYLOAD_TYPE 106

typedef struct {
    RtpSession *rtp;
    srtp_t srtp;
} RtpUserData;

static int rtp_send(void *clientData, const uint8_t *packet, uint16_t len) {
    if (clientData == NULL) {
        fprintf(stderr, "rtp_send: clientData is NULL\n");
        return -1;
    }
    RtpUserData *ud = (RtpUserData *)clientData;
    mblk_t *mp = allocb(len, 0);
    if (mp == NULL) {
        fprintf(stderr, "rtp_send: failed to allocate mblk\n");
        return -1;
    }
    memcpy(mp->b_wptr, packet, len);
    mp->b_wptr += len;
    rtp_session_sendm_with_ts(ud->rtp, mp, 0);
    return 0;
}

static int start_srtp(void *clientData, const bzrtpSrtpSecrets_t *secrets, int32_t verified) {
    RtpUserData *ud = (RtpUserData *)clientData;
    srtp_policy_t inbound = {0}, outbound = {0};
    uint8_t in_key[64];
    memcpy(in_key, secrets->peerSrtpKey, secrets->peerSrtpKeyLength);
    memcpy(in_key + secrets->peerSrtpKeyLength, secrets->peerSrtpSalt, secrets->peerSrtpSaltLength);
    srtp_crypto_policy_set_aes_cm_128_hmac_sha1_80(&inbound.rtp);
    srtp_crypto_policy_set_aes_cm_128_hmac_sha1_80(&inbound.rtcp);
    inbound.ssrc.type = ssrc_any_inbound;
    inbound.key = in_key;
    inbound.window_size = 128;
    inbound.next = &outbound;

    uint8_t out_key[64];
    memcpy(out_key, secrets->selfSrtpKey, secrets->selfSrtpKeyLength);
    memcpy(out_key + secrets->selfSrtpKeyLength, secrets->selfSrtpSalt, secrets->selfSrtpSaltLength);
    srtp_crypto_policy_set_aes_cm_128_hmac_sha1_80(&outbound.rtp);
    srtp_crypto_policy_set_aes_cm_128_hmac_sha1_80(&outbound.rtcp);
    outbound.ssrc.type = ssrc_any_outbound;
    outbound.key = out_key;
    outbound.window_size = 128;
    outbound.next = NULL;

    srtp_create(&ud->srtp, &inbound);
    return 0;
}

struct send_ctx { RtpSession *rtp; srtp_t srtp; snd_pcm_t *cap; };

static void *send_thread(void *p) {
    struct send_ctx *c = p;
    const int FRAME = 160;
    uint8_t buf[FRAME*2];
    uint32_t ts = 0;
    while (1) {
        int got = snd_pcm_readi(c->cap, buf, FRAME);
        if (got > 0) {
            mblk_t *mp = rtp_session_create_packet(c->rtp, 12, buf, got*2);
            int len = msgdsize(mp);
            if (srtp_protect(c->srtp, mp->b_rptr, &len) == srtp_err_status_ok) {
                mp->b_wptr = mp->b_rptr + len;
                rtp_session_sendm_with_ts(c->rtp, mp, ts);
            } else freemsg(mp);
            ts += got;
        }
    }
    return NULL;
}

int main(int argc, char **argv) {
    if (argc != 2) { fprintf(stderr, "usage: %s <peer_ip>\n", argv[0]); return 1; }
    const char *peer_ip = argv[1];

    ortp_init();
    rtp_profile_set_payload(&av_profile,0,&payload_type_pcmu8000);
    RtpSession *rtp = rtp_session_new(RTP_SESSION_SENDRECV);
    rtp_session_set_local_addr(rtp,"0.0.0.0",5004,5005);
    rtp_session_set_remote_addr(rtp, peer_ip,5004);
    rtp_session_enable_rtcp(rtp,1);

    bzrtpContext_t *zctx = bzrtp_createBzrtpContext();
    RtpUserData ud = { rtp, NULL };
    bzrtpCallbacks_t cbs = {0};
    cbs.bzrtp_sendData = rtp_send;
    cbs.bzrtp_startSrtpSession = start_srtp;
    bzrtp_setCallbacks(zctx,&cbs);
    bzrtp_initBzrtpContext(zctx,0x1234);
    int rc = bzrtp_setClientData(zctx,0x1234, &ud);
    if (rc != 0) {
        fprintf(stderr, "bzrtp_setClientData failed: %d\n", rc);
        return 1;
    }
    bzrtp_startChannelEngine(zctx,0x1234);

    while (ud.srtp == NULL) {
        mblk_t *mp = rtp_session_recvm_with_ts(rtp,0);
        if (mp) {
            uint8_t *pkt = mp->b_rptr;
            int len = msgdsize(mp);
            if (rtp_get_payload_type(mp)==ZRTP_PAYLOAD_TYPE)
                bzrtp_processMessage(zctx,0x1234,pkt,len);
            freemsg(mp);
        }
        bzrtp_iterate(zctx,0x1234,ortp_get_cur_time_ms());
    }

    snd_pcm_t *cap, *play;
    snd_pcm_open(&cap, "default", SND_PCM_STREAM_CAPTURE, 0);
    snd_pcm_open(&play, "default", SND_PCM_STREAM_PLAYBACK, 0);
    snd_pcm_set_params(cap, SND_PCM_FORMAT_S16_LE, SND_PCM_ACCESS_RW_INTERLEAVED, 1, 8000, 1, 500000);
    snd_pcm_set_params(play, SND_PCM_FORMAT_S16_LE, SND_PCM_ACCESS_RW_INTERLEAVED, 1, 8000, 1, 500000);

    struct send_ctx ctx = { rtp, ud.srtp, cap };
    pthread_t tid;
    pthread_create(&tid, NULL, send_thread, &ctx);

    while (1) {
        mblk_t *mp = rtp_session_recvm_with_ts(rtp,0);
        if (mp) {
            int len = msgdsize(mp);
            if (srtp_unprotect(ud.srtp, mp->b_rptr, &len) == srtp_err_status_ok) {
                mp->b_wptr = mp->b_rptr + len;
                unsigned char *payload;
                int psize = rtp_get_payload(mp, &payload);
                snd_pcm_writei(play, payload, psize/2);
            }
            freemsg(mp);
        }
    }

    snd_pcm_close(cap);
    snd_pcm_close(play);
    srtp_dealloc(ud.srtp);
    bzrtp_destroyBzrtpContext(zctx,0x1234);
    rtp_session_destroy(rtp);
    ortp_exit();
    return 0;
}
