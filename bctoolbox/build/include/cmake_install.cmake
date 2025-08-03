# Install script for directory: /home/voip2/Desktop/test/bctoolbox/include

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/usr/local")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "1")
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

# Set default install directory permissions.
if(NOT DEFINED CMAKE_OBJDUMP)
  set(CMAKE_OBJDUMP "/usr/bin/objdump")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/bctoolbox" TYPE FILE PERMISSIONS OWNER_READ OWNER_WRITE GROUP_READ WORLD_READ FILES
    "/home/voip2/Desktop/test/bctoolbox/include/bctoolbox/charconv.h"
    "/home/voip2/Desktop/test/bctoolbox/include/bctoolbox/compiler.h"
    "/home/voip2/Desktop/test/bctoolbox/include/bctoolbox/defs.h"
    "/home/voip2/Desktop/test/bctoolbox/include/bctoolbox/exception.hh"
    "/home/voip2/Desktop/test/bctoolbox/include/bctoolbox/utils.hh"
    "/home/voip2/Desktop/test/bctoolbox/include/bctoolbox/list.h"
    "/home/voip2/Desktop/test/bctoolbox/include/bctoolbox/logging.h"
    "/home/voip2/Desktop/test/bctoolbox/include/bctoolbox/map.h"
    "/home/voip2/Desktop/test/bctoolbox/include/bctoolbox/ownership.hh"
    "/home/voip2/Desktop/test/bctoolbox/include/bctoolbox/parser.h"
    "/home/voip2/Desktop/test/bctoolbox/include/bctoolbox/port.h"
    "/home/voip2/Desktop/test/bctoolbox/include/bctoolbox/regex.h"
    "/home/voip2/Desktop/test/bctoolbox/include/bctoolbox/vconnect.h"
    "/home/voip2/Desktop/test/bctoolbox/include/bctoolbox/vfs.h"
    "/home/voip2/Desktop/test/bctoolbox/include/bctoolbox/vfs_standard.h"
    "/home/voip2/Desktop/test/bctoolbox/include/bctoolbox/vfs_encrypted.hh"
    "/home/voip2/Desktop/test/bctoolbox/include/bctoolbox/param_string.h"
    "/home/voip2/Desktop/test/bctoolbox/include/bctoolbox/crypto.h"
    "/home/voip2/Desktop/test/bctoolbox/include/bctoolbox/crypto.hh"
    )
endif()

