############################################################################
# BCToolboxConfig.cmake
# Copyright (C) 2010-2023 Belledonne Communications, Grenoble France
#
############################################################################
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
############################################################################
#
# Config file for the bctoolbox package.
#
# Components
# ^^^^^^^^^^
#
# This config file will define the component: tester.
#
#
# Targets
# ^^^^^^^
#
# The following targets are always defined:
#  bctoolbox - The bctoolbox library target
#
# The following targets may be defined according to the asked components:
#  bctoolbox-tester - The bctoolbox-tester library target (defined if the tester is asked for)
#
#
# Result variables
# ^^^^^^^^^^^^^^^^
#
# This config file will set the following variables in your project:
#
#  BCToolbox_FOUND - The bctoolbox library has been found
#  BCToolbox_TARGET - The name of the CMake target for the bctoolbox library
#  BCToolbox_CMAKE_DIR - The bctoolbox CMake directory
#  BCToolbox_CMAKE_UTILS - The path to the bctoolbox CMake utils script
#  BCToolbox_tester_FOUND - The bctoolbox-tester library has been found
#  BCToolbox_tester_TARGET - The name of the CMake target for the bctoolbox-tester library


####### Expanded from @PACKAGE_INIT@ by configure_package_config_file() #######
####### Any changes to this file will be overwritten by the next CMake run ####
####### The input file was BCToolboxConfig.cmake.in                            ########

get_filename_component(PACKAGE_PREFIX_DIR "${CMAKE_CURRENT_LIST_DIR}/../../../" ABSOLUTE)

macro(set_and_check _var _file)
  set(${_var} "${_file}")
  if(NOT EXISTS "${_file}")
    message(FATAL_ERROR "File or directory ${_file} referenced by variable ${_var} does not exist !")
  endif()
endmacro()

macro(check_required_components _NAME)
  foreach(comp ${${_NAME}_FIND_COMPONENTS})
    if(NOT ${_NAME}_${comp}_FOUND)
      if(${_NAME}_FIND_REQUIRED_${comp})
        set(${_NAME}_FOUND FALSE)
      endif()
    endif()
  endforeach()
endmacro()

####################################################################################

include(CMakeFindDependencyMacro)
include("${CMAKE_CURRENT_LIST_DIR}/BCToolboxTargets.cmake")

set(BCToolbox_TARGET bctoolbox)

if(NO)
	set(BCToolbox_tester_FOUND TRUE)
	set(BCToolbox_tester_TARGET bctoolbox-tester)
endif()

# We must propagate the public dependencies and the private dependencies for static build
include(CMakeFindDependencyMacro)
if()
else()
	list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}")
	if()
		find_dependency(Iconv)
	endif()
	if(TRUE)
		find_dependency(MbedTLS)
	endif()
	if(1)
		find_dependency(Decaf)
	endif()
	find_dependency(BCUnit)
endif()

set_and_check(BCToolbox_CMAKE_DIR "${PACKAGE_PREFIX_DIR}/share/BCToolbox/cmake")
set_and_check(BCToolbox_CMAKE_UTILS "${PACKAGE_PREFIX_DIR}/share/BCToolbox/cmake/BCToolboxCMakeUtils.cmake")
include("${BCToolbox_CMAKE_UTILS}")

check_required_components(BCToolbox)
