set(CMAKE_Fortran_COMPILER "/opt/cray/craype/2.3.0/bin/ftn")
set(CMAKE_Fortran_COMPILER_ARG1 "")
set(CMAKE_Fortran_COMPILER_ID "Intel")
set(CMAKE_Fortran_COMPILER_VERSION "18.0.1.20171018")
set(CMAKE_Fortran_COMPILER_WRAPPER "CrayPrgEnv")
set(CMAKE_Fortran_PLATFORM_ID "Linux")
set(CMAKE_Fortran_SIMULATE_ID "")
set(CMAKE_Fortran_SIMULATE_VERSION "")


set(CMAKE_AR "/usr/bin/ar")
set(CMAKE_Fortran_COMPILER_AR "")
set(CMAKE_RANLIB "/usr/bin/ranlib")
set(CMAKE_Fortran_COMPILER_RANLIB "")
set(CMAKE_COMPILER_IS_GNUG77 )
set(CMAKE_Fortran_COMPILER_LOADED 1)
set(CMAKE_Fortran_COMPILER_WORKS TRUE)
set(CMAKE_Fortran_ABI_COMPILED TRUE)
set(CMAKE_COMPILER_IS_MINGW )
set(CMAKE_COMPILER_IS_CYGWIN )
if(CMAKE_COMPILER_IS_CYGWIN)
  set(CYGWIN 1)
  set(UNIX 1)
endif()

set(CMAKE_Fortran_COMPILER_ENV_VAR "FC")

set(CMAKE_Fortran_COMPILER_SUPPORTS_F90 1)

if(CMAKE_COMPILER_IS_MINGW)
  set(MINGW 1)
endif()
set(CMAKE_Fortran_COMPILER_ID_RUN 1)
set(CMAKE_Fortran_SOURCE_FILE_EXTENSIONS f;F;fpp;FPP;f77;F77;f90;F90;for;For;FOR;f95;F95)
set(CMAKE_Fortran_IGNORE_EXTENSIONS h;H;o;O;obj;OBJ;def;DEF;rc;RC)
set(CMAKE_Fortran_LINKER_PREFERENCE 20)
if(UNIX)
  set(CMAKE_Fortran_OUTPUT_EXTENSION .o)
else()
  set(CMAKE_Fortran_OUTPUT_EXTENSION .obj)
endif()

# Save compiler ABI information.
set(CMAKE_Fortran_SIZEOF_DATA_PTR "8")
set(CMAKE_Fortran_COMPILER_ABI "ELF")
set(CMAKE_Fortran_LIBRARY_ARCHITECTURE "")

if(CMAKE_Fortran_SIZEOF_DATA_PTR AND NOT CMAKE_SIZEOF_VOID_P)
  set(CMAKE_SIZEOF_VOID_P "${CMAKE_Fortran_SIZEOF_DATA_PTR}")
endif()

if(CMAKE_Fortran_COMPILER_ABI)
  set(CMAKE_INTERNAL_PLATFORM_ABI "${CMAKE_Fortran_COMPILER_ABI}")
endif()

if(CMAKE_Fortran_LIBRARY_ARCHITECTURE)
  set(CMAKE_LIBRARY_ARCHITECTURE "")
endif()





set(CMAKE_Fortran_IMPLICIT_INCLUDE_DIRECTORIES "/opt/cray/hdf5/1.8.14/INTEL/14.0/include;/opt/cray/netcdf/4.3.3.1/INTEL/14.0/include;/opt/cray/mpt/7.2.0/gni/mpich2-intel/140/include;/opt/cray/libsci/13.0.3/INTEL/140/x86_64/include;/opt/cray/alps/5.2.4-2.0502.9822.32.1.ari/include;/opt/cray/rca/1.0.0-2.0502.57212.2.56.ari/include;/opt/cray/xpmem/0.1-2.0502.57015.1.15.ari/include;/opt/cray/gni-headers/4.0-1.0502.10317.9.2.ari/include;/opt/cray/pmi/5.0.6-1.0000.10439.140.2.ari/include;/opt/cray/ugni/6.0-1.0502.10245.9.9.ari/include;/opt/cray/udreg/2.3.2-1.0502.9889.2.20.ari/include;/opt/cray/wlm_detect/1.0-1.0502.64649.2.1.ari/include;/opt/cray/krca/1.0.0-2.0502.67049.8.22.ari/include;/opt/cray-hss-devel/7.2.0/include;/opt/intel/compilers_and_libraries_2018.1.163/linux/ipp/include;/opt/intel/compilers_and_libraries_2018.1.163/linux/mkl/include;/opt/intel/compilers_and_libraries_2018.1.163/linux/tbb/include;/opt/intel/compilers_and_libraries_2018.1.163/linux/compiler/include/intel64;/opt/intel/compilers_and_libraries_2018.1.163/linux/compiler/include/icc;/opt/intel/compilers_and_libraries_2018.1.163/linux/compiler/include;/usr/local/include;/opt/gcc/6.3.0/snos/lib/gcc/x86_64-suse-linux/6.3.0/include;/opt/gcc/6.3.0/snos/lib/gcc/x86_64-suse-linux/6.3.0/include-fixed;/opt/gcc/6.3.0/snos/include;/usr/include")
set(CMAKE_Fortran_IMPLICIT_LINK_LIBRARIES "AtpSigHandler;AtpSigHCommData;pthread;mpichf90_intel;rt;ugni;pmi;imf;m;pthread;dl;hdf5hl_fortran;z;rt;imf;m;pthread;dl;hdf5_fortran;z;rt;imf;m;pthread;dl;netcdff;imf;m;pthread;dl;netcdf;dl;imf;m;hdf5_hl;z;rt;dl;imf;m;hdf5;z;rt;dl;imf;m;sci_intel_mpi;sci_intel;imf;m;dl;mpich_intel;rt;ugni;pthread;pmi;imf;m;dl;pmi;pthread;alpslli;pthread;wlm_detect;alpsutil;pthread;rca;xpmem;ugni;pthread;udreg;sci_intel;imf;m;dl;imf;m;pthread;ifport;ifcore;imf;svml;m;ipgo;irc;svml;c;gcc;irc_s;dl;c")
set(CMAKE_Fortran_IMPLICIT_LINK_DIRECTORIES "/opt/cray/hdf5/1.8.14/INTEL/14.0/lib;/opt/cray/netcdf/4.3.3.1/INTEL/14.0/lib;/opt/cray/dmapp/default/lib64;/opt/cray/mpt/7.2.0/gni/mpich2-intel/140/lib;/opt/cray/libsci/13.0.3/INTEL/140/x86_64/lib;/opt/cray/alps/5.2.4-2.0502.9822.32.1.ari/lib64;/opt/cray/rca/1.0.0-2.0502.57212.2.56.ari/lib64;/opt/cray/xpmem/0.1-2.0502.57015.1.15.ari/lib64;/opt/cray/pmi/5.0.6-1.0000.10439.140.2.ari/lib64;/opt/cray/ugni/6.0-1.0502.10245.9.9.ari/lib64;/opt/cray/udreg/2.3.2-1.0502.9889.2.20.ari/lib64;/opt/cray/atp/1.8.1/libApp;/opt/cray/wlm_detect/1.0-1.0502.64649.2.1.ari/lib64;/opt/intel/compilers_and_libraries_2018.1.163/linux/compiler/lib/intel64;/opt/intel/compilers_and_libraries_2018.1.163/linux/ipp/lib/intel64;/opt/intel/compilers_and_libraries_2018.1.163/linux/mkl/lib/intel64;/opt/intel/compilers_and_libraries_2018.1.163/linux/tbb/lib/intel64/gcc4.1;/opt/intel/compilers_and_libraries_2018.1.163/linux/compiler/lib/intel64_lin;/opt/gcc/6.3.0/snos/lib/gcc/x86_64-suse-linux/6.3.0;/opt/gcc/6.3.0/snos/lib64;/lib64;/usr/lib64;/opt/gcc/6.3.0/snos/lib;/lib;/usr/lib")
set(CMAKE_Fortran_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES "")
