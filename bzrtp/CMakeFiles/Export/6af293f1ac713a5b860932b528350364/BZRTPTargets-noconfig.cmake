#----------------------------------------------------------------
# Generated CMake target import file.
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "bzrtp" for configuration ""
set_property(TARGET bzrtp APPEND PROPERTY IMPORTED_CONFIGURATIONS NOCONFIG)
set_target_properties(bzrtp PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_NOCONFIG "C;CXX"
  IMPORTED_LOCATION_NOCONFIG "${_IMPORT_PREFIX}/lib/libbzrtp.a"
  )

list(APPEND _cmake_import_check_targets bzrtp )
list(APPEND _cmake_import_check_files_for_bzrtp "${_IMPORT_PREFIX}/lib/libbzrtp.a" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
