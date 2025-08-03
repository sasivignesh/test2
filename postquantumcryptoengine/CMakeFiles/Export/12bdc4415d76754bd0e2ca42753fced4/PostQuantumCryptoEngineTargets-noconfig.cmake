#----------------------------------------------------------------
# Generated CMake target import file.
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "postquantumcryptoengine" for configuration ""
set_property(TARGET postquantumcryptoengine APPEND PROPERTY IMPORTED_CONFIGURATIONS NOCONFIG)
set_target_properties(postquantumcryptoengine PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_NOCONFIG "C;CXX"
  IMPORTED_LOCATION_NOCONFIG "${_IMPORT_PREFIX}/lib/libpostquantumcryptoengine.a"
  )

list(APPEND _cmake_import_check_targets postquantumcryptoengine )
list(APPEND _cmake_import_check_files_for_postquantumcryptoengine "${_IMPORT_PREFIX}/lib/libpostquantumcryptoengine.a" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
