#! /usr/bin/env bash
set -eux

target=${target:-"NULL"}

echo target is $target

if [[ $target == "linux.gnu" || $target == "linux.intel" ]]; then
 unset -f module
else
 source ./sorc/machine-setup.sh > /dev/null 2>&1
fi

export MOD_PATH
source ./modulefiles/build.$target             > /dev/null 2>&1
# source ./modulefiles/build.$target         


#
# --- Build all programs.
#

rm -fr ./build
mkdir ./build
cd ./build

echo target is $target

# echo look for NEMSIO in environment
# env | grep NEMSIO

# if [[ $target == "wcoss_cray" || $target == "wcoss2" ]]; then
if [[ $target == "wcoss_cray" ]]; then
	 echo doing this wcoss_cray cmake
  cmake .. -DCMAKE_INSTALL_PREFIX=../ -DEMC_EXEC_DIR=ON
else
	echo doing this non-wcoss_cray cmake
  cmake .. -DCMAKE_Fortran_COMPILER=ftn -DCMAKE_C_COMPILER=icc -DCMAKE_INSTALL_PREFIX=../ -DEMC_EXEC_DIR=ON
	echo past doing this non-wcoss_cray cmake
fi

make -j 8 VERBOSE=1

make install

exit
