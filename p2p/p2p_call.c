#include <ortp/ortp.h>
#include <bzrtp/bzrtp.h>
#include <srtp2/srtp.h>
#include <alsa/asoundlib.h>
#include <stdio.h>
#include <string.h>

typedef struct {
    RtpSession *rtp;
    srtp_t srtp;
} RtpUserData;

static int rtp_send(bzrtpContext_t *ctx, const uint8_t *msg, size_t len) {
    RtpSession *s = (RtpSession*)bzrtp_getUserData(ctx);
    return rtp_session_send_with_ts(s, msg, len, 0);
    RtpUserData *ud = (RtpUserData*)bzrtp_getUserData(ctx);
    int out_len = (int)len;
    if (ud->srtp) {
        uint8_t *buf = (uint8_t*)msg; /* SRTP modifies packet in place */
        if (srtp_protect(ud->srtp, buf, &out_len) != srtp_err_status_ok)
            return -1;
        return rtp_session_send_with_ts(ud->rtp, buf, out_len, 0);
    }
    return rtp_session_send_with_ts(ud->rtp, msg, len, 0);
}

int main(int argc, char **argv) {
    if (argc != 2) { fprintf(stderr, "usage: %s <peer_ip>\n", argv[0]); return 1; }
    const char *peer_ip = argv[1];

    ortp_init();
    rtp_profile_set_payload(&av_profile,0,&payload_type_pcmu);
    RtpSession *rtp = rtp_session_new(RTP_SESSION_SENDRECV);
    rtp_session_set_local_addr(rtp,"0.0.0.0",5004,5005);
    rtp_session_set_remote_addr(rtp, peer_ip,5004);
    rtp_session_enable_rtcp(rtp,1);

    bzrtpContext_t *zctx = bzrtp_createBzrtpContext();
    RtpUserData ud = {0};
    ud.rtp = rtp;
    bzrtpCallbacks_t cbs = {0};
    cbs.bzrtp_sendData = rtp_send;
    bzrtp_setCallbacks(zctx,&cbs);
    bzrtp_setUserData(zctx, rtp);
    bzrtp_setUserData(zctx, &ud);
    bzrtp_initBzrtpContext(zctx,0x1234);
    bzrtp_startChannelEngine(zctx,0x1234);

    while (!bzrtp_isSecure(zctx)) {
        mblk_t *mp = rtp_session_recvm_with_ts(rtp,NULL);
        if (mp) {
            uint8_t *pkt = mp->b_rptr;
            int len = msgdsize(mp);
            if (rtp_get_payload_type(mp)==ZRTP_PAYLOAD_TYPE)
                bzrtp_processMessage(zctx,0x1234,pkt,len);
            freemsg(mp);
        }
        bzrtp_iterate(zctx,0x1234,ortp_get_cur_time_ms());
    }

    bzrtpSrtpSecrets_t secrets; memset(&secrets,0,sizeof(secrets));
    bzrtp_getSrtpSecrets(zctx,0x1234,&secrets);
    srtp_policy_t policy; srtp_crypto_policy_set_aes_cm_128_hmac_sha1_80(&policy.rtp);
    srtp_crypto_policy_set_aes_cm_128_hmac_sha1_80(&policy.rtcp);
    policy.ssrc.type = ssrc_any_inbound;
    policy.key = secrets.keyAndSalt;
    policy.window_size = 128; policy.next = NULL;
    srtp_policy_t policy_in, policy_out;
    srtp_crypto_policy_set_aes_cm_128_hmac_sha1_80(&policy_in.rtp);
    srtp_crypto_policy_set_aes_cm_128_hmac_sha1_80(&policy_in.rtcp);
    policy_in.ssrc.type = ssrc_any_inbound;
    policy_in.key = secrets.keyAndSaltRS;
    policy_in.window_size = 128;
    policy_in.allow_repeat_tx = 0;
    policy_in.next = &policy_out;

    srtp_crypto_policy_set_aes_cm_128_hmac_sha1_80(&policy_out.rtp);
    srtp_crypto_policy_set_aes_cm_128_hmac_sha1_80(&policy_out.rtcp);
    policy_out.ssrc.type = ssrc_any_outbound;
    policy_out.key = secrets.keyAndSaltLS;
    policy_out.window_size = 128;
    policy_out.allow_repeat_tx = 0;
    policy_out.next = NULL;

    srtp_t srtp_session;
    srtp_create(&srtp_session, &policy);
    srtp_create(&srtp_session, &policy_in);
    ud.srtp = srtp_session;

    /* TODO: add ALSA capture/playback and SRTP encrypt/decrypt of RTP payloads */
    /* TODO: add ALSA capture/playback */
    mblk_t *mp = rtp_session_recvm_with_ts(rtp,NULL);
    if (mp) {
        int len = msgdsize(mp);
        srtp_unprotect(srtp_session, mp->b_rptr, &len);
        /* TODO: decode or play payload in mp->b_rptr of length len */
        freemsg(mp);
    }

    srtp_dealloc(srtp_session);
    bzrtp_destroyBzrtpContext(zctx);
    rtp_session_destroy(rtp);
    ortp_exit();
    return 0;
}
