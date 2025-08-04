#----------------------------------------------------------------
# Generated CMake target import file.
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "bctoolbox" for configuration ""
set_property(TARGET bctoolbox APPEND PROPERTY IMPORTED_CONFIGURATIONS NOCONFIG)
set_target_properties(bctoolbox PROPERTIES
  IMPORTED_LOCATION_NOCONFIG "${_IMPORT_PREFIX}/lib/libbctoolbox.so.1"
  IMPORTED_SONAME_NOCONFIG "libbctoolbox.so.1"
  )

list(APPEND _cmake_import_check_targets bctoolbox )
list(APPEND _cmake_import_check_files_for_bctoolbox "${_IMPORT_PREFIX}/lib/libbctoolbox.so.1" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
