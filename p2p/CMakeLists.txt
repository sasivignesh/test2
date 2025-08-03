cmake_minimum_required(VERSION 3.16)
project(p2p_call C)

find_package(PkgConfig REQUIRED)
find_package(bzrtp REQUIRED)
pkg_check_modules(BCTOOLBOX REQUIRED bctoolbox)
pkg_check_modules(ORTP REQUIRED ortp)
pkg_check_modules(SRTP REQUIRED libsrtp2)
pkg_check_modules(ALSA REQUIRED alsa)

add_executable(p2p_call p2p_call.c)
target_link_libraries(p2p_call
    PRIVATE
        bzrtp
        ${BCTOOLBOX_LIBRARIES}
        ${ORTP_LIBRARIES}
        ${SRTP_LIBRARIES}
        ${ALSA_LIBRARIES}
        pthread
)
target_link_directories(p2p_call PRIVATE
    ${BCTOOLBOX_LIBRARY_DIRS}
    ${ORTP_LIBRARY_DIRS}
    ${SRTP_LIBRARY_DIRS}
    ${ALSA_LIBRARY_DIRS}
)
target_include_directories(p2p_call PRIVATE
    ${BCTOOLBOX_INCLUDE_DIRS}
    ${ORTP_INCLUDE_DIRS}
    ${SRTP_INCLUDE_DIRS}
    ${ALSA_INCLUDE_DIRS}
)
