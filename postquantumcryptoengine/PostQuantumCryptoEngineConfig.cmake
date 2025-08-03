############################################################################
# PostQuantumCryptoEngineConfig.cmake
# Copyright (C) 2015-2023  Belledonne Communications, Grenoble France
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
# Config file for the postquantumcryptoengine package.
#
# Targets
# ^^^^^^^
#
# The following targets are defined:
#  postquantumcryptoengine - The postquantumcryptoengine library target
#
#
# Result variables
# ^^^^^^^^^^^^^^^^
#
# This config file will set the following variables in your project:
#
#  PostQuantumCryptoEngine_FOUND - The postquantumcryptoengine library has been found
#  PostQuantumCryptoEngine_TARGET - The name of the CMake target for the postquantumcryptoengine library



####### Expanded from @PACKAGE_INIT@ by configure_package_config_file() #######
####### Any changes to this file will be overwritten by the next CMake run ####
####### The input file was PostQuantumCryptoEngineConfig.cmake.in                            ########

get_filename_component(PACKAGE_PREFIX_DIR "${CMAKE_CURRENT_LIST_DIR}/../../../" ABSOLUTE)

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

include("${CMAKE_CURRENT_LIST_DIR}/PostQuantumCryptoEngineTargets.cmake")

set(PostQuantumCryptoEngine_TARGET postquantumcryptoengine)

# We must propagate the public dependencies and the private dependencies for static build
include(CMakeFindDependencyMacro)
if()
else()
	list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}")
	find_dependency(BCToolbox)
	find_dependency(liboqs)
endif()

check_required_components(PostQuantumCryptoEngine)
