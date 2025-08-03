cmake_minimum_required(VERSION 3.16)
project(p2p_call C)

find_package(PkgConfig REQUIRED)
find_package(BZRTP REQUIRED)
pkg_check_modules(ORTP REQUIRED ortp)
pkg_check_modules(SRTP REQUIRED libsrtp2)

add_executable(p2p_call p2p_call.c)
target_link_libraries(p2p_call
    PRIVATE
        BZRTP::bzrtp
        ${ORTP_LIBRARIES}
        ${SRTP_LIBRARIES}
)
target_include_directories(p2p_call PRIVATE
    ${ORTP_INCLUDE_DIRS}
    ${SRTP_INCLUDE_DIRS}
)
