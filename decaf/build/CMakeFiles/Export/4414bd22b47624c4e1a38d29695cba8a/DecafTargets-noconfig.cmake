#----------------------------------------------------------------
# Generated CMake target import file.
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "decaf-static" for configuration ""
set_property(TARGET decaf-static APPEND PROPERTY IMPORTED_CONFIGURATIONS NOCONFIG)
set_target_properties(decaf-static PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_NOCONFIG "C"
  IMPORTED_LOCATION_NOCONFIG "${_IMPORT_PREFIX}/lib/libdecaf.a"
  )

list(APPEND _cmake_import_check_targets decaf-static )
list(APPEND _cmake_import_check_files_for_decaf-static "${_IMPORT_PREFIX}/lib/libdecaf.a" )

# Import target "decaf" for configuration ""
set_property(TARGET decaf APPEND PROPERTY IMPORTED_CONFIGURATIONS NOCONFIG)
set_target_properties(decaf PROPERTIES
  IMPORTED_LOCATION_NOCONFIG "${_IMPORT_PREFIX}/lib/libdecaf.so.0"
  IMPORTED_SONAME_NOCONFIG "libdecaf.so.0"
  )

list(APPEND _cmake_import_check_targets decaf )
list(APPEND _cmake_import_check_files_for_decaf "${_IMPORT_PREFIX}/lib/libdecaf.so.0" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
