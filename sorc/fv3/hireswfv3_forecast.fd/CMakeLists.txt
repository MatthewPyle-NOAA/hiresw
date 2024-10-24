cmake_minimum_required(VERSION 3.15)

foreach(env_var IN ITEMS CMAKE_C_COMPILER CMAKE_CXX_COMPILER CMAKE_Fortran_COMPILER)
  if(NOT DEFINED ENV{${env_var}})
    message(FATAL_ERROR "${env_var} is not defined")
  endif()
endforeach()

set(CMAKE_C_COMPILER $ENV{CMAKE_C_COMPILER})
set(CMAKE_CXX_COMPILER $ENV{CMAKE_CXX_COMPILER})
set(CMAKE_Fortran_COMPILER $ENV{CMAKE_Fortran_COMPILER})
set(CMAKE_Platform $ENV{CMAKE_Platform})

project(ufs
        VERSION 1.0
        LANGUAGES C CXX Fortran)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

set(32BIT           OFF CACHE BOOL "Enable 32BIT (single precision arithmetic in dycore)")
set(AVX2            ON  CACHE BOOL "Enable AVX2 instruction set")
set(SIMDMULTIARCH   OFF CACHE BOOL "Enable multi-target SIMD instruction sets")
set(CCPP            ON  CACHE BOOL "Enable CCPP")
set(DEBUG           OFF CACHE BOOL "Enable DEBUG mode")
set(DEBUG_LINKMPI   ON  CACHE BOOL "Enable linkmpi option when DEBUG mode is on")
set(INLINE_POST     OFF CACHE BOOL "Enable inline post")
set(MULTI_GASES     OFF CACHE BOOL "Enable MULTI_GASES")
set(OPENMP          ON  CACHE BOOL "Enable OpenMP threading")
set(PARALLEL_NETCDF OFF CACHE BOOL "Enable parallel NetCDF")
set(QUAD_PRECISION  ON  CACHE BOOL "Enable QUAD_PRECISION (for certain grid metric terms in dycore)")
set(REPRO           OFF CACHE BOOL "Enable REPRO mode")
set(WW3             OFF CACHE BOOL "Enable WW3")

if(CMAKE_Platform)
  message("")
  if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/cmake/configure_${CMAKE_Platform}.cmake)
    message("Setting configuration for ${CMAKE_Platform}")
    include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/configure_${CMAKE_Platform}.cmake)
  else()
    message("Platform '${CMAKE_Platform}' configuration file does not exist")
  endif()
endif()

message("")
message("32BIT ............ ${32BIT}")
message("AVX2 ............. ${AVX2}")
message("SIMDMULTIARCH      ${SIMDMULTIARCH}")
message("CCPP ............. ${CCPP}")
message("DEBUG ............ ${DEBUG}")
message("DEBUG_LINKMPI .... ${DEBUG_LINKMPI}")
message("INLINE_POST ...... ${INLINE_POST}")
message("MULTI_GASES ...... ${MULTI_GASES}")
message("OPENMP ........... ${OPENMP}")
message("PARALLEL_NETCDF .. ${PARALLEL_NETCDF}")
message("QUAD_PRECISION ... ${QUAD_PRECISION}")
message("REPRO ............ ${REPRO}")
message("WW3 .............. ${WW3}")
message("")

get_filename_component (C_COMPILER_NAME ${CMAKE_C_COMPILER} NAME)
get_filename_component (CXX_COMPILER_NAME ${CMAKE_CXX_COMPILER} NAME)
get_filename_component (Fortran_COMPILER_NAME ${CMAKE_Fortran_COMPILER} NAME)
message("C       compiler: ${CMAKE_C_COMPILER_ID} ${CMAKE_C_COMPILER_VERSION} (${C_COMPILER_NAME})")
message("CXX     compiler: ${CMAKE_CXX_COMPILER_ID} ${CMAKE_CXX_COMPILER_VERSION} (${CXX_COMPILER_NAME})")
message("Fortran compiler: ${CMAKE_Fortran_COMPILER_ID} ${CMAKE_Fortran_COMPILER_VERSION} (${Fortran_COMPILER_NAME})")
message("")

if (CMAKE_Fortran_COMPILER_ID MATCHES "GNU" AND CMAKE_Fortran_COMPILER_VERSION VERSION_LESS 9.0.0)
  message(FATAL_ERROR "GNU Compiler >= 9 is required")
endif()

include(cmake/${CMAKE_Fortran_COMPILER_ID}.cmake)
message("")

find_package(NetCDF REQUIRED C Fortran)
find_package(MPI REQUIRED)
if(OPENMP)
  find_package(OpenMP REQUIRED)
endif()
find_package(ESMF MODULE REQUIRED)

find_package(bacio REQUIRED)
find_package(nemsio REQUIRED)
find_package(sp REQUIRED)
find_package(w3emc REQUIRED)
find_package(w3nco REQUIRED)
if(INLINE_POST)
  find_package(nceppost REQUIRED)
endif()
# See https://github.com/NOAA-EMC/NCEPLIBS-nemsio/pull/22
target_link_libraries(nemsio::nemsio INTERFACE w3emc::w3emc_d bacio::bacio_4)

if(CCPP)
  find_package(Python 3 QUIET COMPONENTS Interpreter)
  if (NOT Python_Interpreter_FOUND)
    find_package(Python 2.7 QUIET REQUIRED COMPONENTS Interpreter)
  endif()
  message("Found Python: ${Python_EXECUTABLE}")
endif()

###############################################################################
### FMS
###############################################################################
include(fms_files.cmake)
add_library(fms ${fms_src_files})
# stupid cmake can not figure out dependency of fft.F90 on fft99.F90 because 'use fft99_mod' is inside ifdefs
set_property(SOURCE FMS/fft/fft.F90 APPEND_STRING PROPERTY COMPILE_FLAGS "-DSGICRAY=0 -DNAGFFT=0")

list(APPEND _fms_defs_public use_libMPI
                             use_netCDF
                             GFS_PHYS
                             INTERNAL_FILE_NML)
if(QUAD_PRECISION)
  list(APPEND _fms_defs_public ENABLE_QUAD_PRECISION)
endif()
target_compile_definitions(fms PUBLIC "${_fms_defs_public}")

if(32BIT)
  list(APPEND _fms_defs_private OVERLOAD_R4
                                OVERLOAD_R8)
endif()
target_compile_definitions(fms PRIVATE "${_fms_defs_private}")

target_include_directories(fms PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/FMS/include>
                                      $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/FMS/fms>
                                      $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/FMS/fms2_io/include>
                                      $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/FMS/mpp/include>)
target_link_libraries(fms PUBLIC MPI::MPI_Fortran
                                 NetCDF::NetCDF_Fortran)
if(OpenMP_Fortran_FOUND)
  target_link_libraries(fms PUBLIC OpenMP::OpenMP_Fortran)
endif()
set_target_properties(fms PROPERTIES ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/FMS)
set_target_properties(fms PROPERTIES Fortran_MODULE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/FMS/mod)
target_include_directories(fms INTERFACE $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/FMS/mod>
                                         $<INSTALL_INTERFACE:FMS/mod>)

###############################################################################
### stochastic_physics
###############################################################################
add_subdirectory(stochastic_physics)

###############################################################################
### FV3
###############################################################################
add_subdirectory(FV3)

###############################################################################
### WW3
###############################################################################
if(WW3)
  if(CMAKE_Platform)
    if(${CMAKE_Platform} STREQUAL "hera.intel")
      set(WW3_COMP "hera")
    elseif(${CMAKE_Platform} STREQUAL "orion.intel")
      set(WW3_COMP "orion")
    else()
      set(WW3_COMP ${CMAKE_Platform})
    endif()
  endif()
  message("Build WW3:")
  message("   run: ${CMAKE_BUILD_TOOL} WW3_PARCOMPN=4 WW3_COMP=${WW3_COMP} ww3_nemslibonly")
  message("   in:  ${CMAKE_CURRENT_SOURCE_DIR}/WW3/model/esmf")
  message("")

  add_custom_target(ww3_nems
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/WW3/model/esmf
    COMMAND ${CMAKE_BUILD_TOOL} WW3_PARCOMPN=4 WW3_COMP=${WW3_COMP} ww3_nemslibonly > ${CMAKE_CURRENT_BINARY_DIR}/ww3_make.log 2>&1)

    set(WW3_LIBS ${CMAKE_CURRENT_SOURCE_DIR}/WW3/model/obj/libww3_multi_esmf.a)
endif()

###############################################################################
### NEMS (ufs)
###############################################################################
list(APPEND _nems_srcs NEMS/src/module_NEMS_UTILS.F90
                       NEMS/src/module_MEDIATOR_methods.F90
                       NEMS/src/module_MEDIATOR.F90
                       NEMS/src/module_MEDIATOR_SpaceWeather.F90
                       NEMS/src/module_EARTH_INTERNAL_STATE.F90
                       NEMS/src/module_EARTH_GRID_COMP.F90
                       NEMS/src/module_NEMS_INTERNAL_STATE.F90
                       NEMS/src/module_NEMS_GRID_COMP.F90
                       NEMS/src/module_NEMS_Rusage.F90
                       NEMS/src/nems_c_rusage.c
                       NEMS/src/ENS_Cpl/ENS_CplComp_ESMFMod_STUB.F90)

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/NEMS/src/ESMFVersionDefine_ESMF_NUOPC.h
               ${CMAKE_CURRENT_BINARY_DIR}/NEMS/src/ESMFVersionDefine.h
               COPYONLY)
# until we remove "../ESMFVersionDefine.h" from ENS_Cpl/ENS_CplComp_ESMFMod_STUB.F90
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/NEMS/src/ESMFVersionDefine_ESMF_NUOPC.h
               ${CMAKE_CURRENT_BINARY_DIR}/NEMS/ESMFVersionDefine.h
               COPYONLY)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/NEMS/src/ESMFConvenienceMacros.h
               ${CMAKE_CURRENT_BINARY_DIR}/NEMS/src/ESMFConvenienceMacros.h
               COPYONLY)

add_library(ufs ${_nems_srcs})

list(APPEND _ufs_defs_private ESMF_VERSION_MAJOR=${ESMF_VERSION_MAJOR}
                              FRONT_FMS
                              FRONT_FV3=fv3gfs_cap_mod)

set_target_properties(ufs PROPERTIES Fortran_MODULE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/mod)
target_include_directories(ufs PRIVATE ${CMAKE_CURRENT_BINARY_DIR}/NEMS/src)

if(WW3)
  list(APPEND _ufs_defs_private FRONT_WW3=WMESMFMD)
  target_include_directories(ufs PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/WW3/model/mod)
  add_dependencies(ufs ww3_nems)
  target_link_libraries(ufs PUBLIC ${WW3_LIBS})
endif()

target_include_directories(ufs INTERFACE $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/mod>
                                         $<INSTALL_INTERFACE:mod>)

target_compile_definitions(ufs PRIVATE ${_ufs_defs_private})
target_link_libraries(ufs PUBLIC esmf
                                 fv3atm)

###############################################################################
### UFS executable
###############################################################################
add_executable(ufs_model NEMS/src/MAIN_NEMS.F90)

list(APPEND _ufs_model_defs_private ESMF_VERSION_MAJOR=${ESMF_VERSION_MAJOR})

set_target_properties(ufs_model PROPERTIES Fortran_MODULE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/mod)

target_include_directories(ufs_model PRIVATE ${CMAKE_CURRENT_BINARY_DIR}/NEMS/src)

if(WW3)
  list(APPEND _ufs_model_defs_private FRONT_WW3=WMESMFMD)
  target_include_directories(ufs_model PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/WW3/model/mod)
  add_dependencies(ufs_model ww3_nems)
endif()

target_compile_definitions(ufs_model PRIVATE "${_ufs_model_defs_private}")

target_link_libraries(ufs_model PRIVATE ufs
                                        esmf
                                        NetCDF::NetCDF_Fortran
                                        ${MKL_LIB})

###############################################################################
### Install
###############################################################################
install(
  TARGETS ufs_model ufs fms
  EXPORT ufs-config
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib)

install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/mod DESTINATION ${CMAKE_INSTALL_PREFIX})

install(EXPORT ufs-config
  DESTINATION lib/cmake
)

###############################################################################
### done
###############################################################################
