#----------------------------------------------------------------
# Generated CMake target import file for configuration "Release".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "ccpp" for configuration "Release"
set_property(TARGET ccpp APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(ccpp PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "Fortran"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libccpp.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS ccpp )
list(APPEND _IMPORT_CHECK_FILES_FOR_ccpp "${_IMPORT_PREFIX}/lib/libccpp.a" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
