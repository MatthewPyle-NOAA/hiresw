#! /bin/ksh --login

# module unload NetCDF/4.2/serial

# module load NetCDF/3.6.3

### BUILD ARW

export WRF_NMM_CORE=0
export WRF_EM_CORE=1

TARGDIR=../../exec

############################

./clean -a
cp configure.wrf_wcoss configure.wrf

./compile -j4 em_real > compile_arw_fast.log 2>&1
./compile -j4 em_real > compile_arw_fastrealbonus.log 2>&1

cp ./main/real.exe $TARGDIR/hiresw_wrfarwfcst_init
cp ./main/wrf.exe  $TARGDIR/hiresw_wrfarwfcst

############################

exit
