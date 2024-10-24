#! /bin/sh

#################################
# FV3 build
#################################

# 1st time only
if [ ! -e fv3/hireswfv3_utils.fd ]
then
# ./manage_externals/checkout_externals
git clone -b hrefv3.1-wcoss2 https://github.com/GeorgeGayno-NOAA/UFS_UTILS.git fv3/hireswfv3_utils.fd
else
echo "already ran checkout_externals"
fi

cd fv3

# 1st time only
if [ ! -e ../../fix/fv3 ]
then
./link_fix.sh
fi

# just in case - needed for FV3 model build

module load intel/19.1.3.304
module load python/3.8.6

# /gpfs/dell1/nco/ops/nwtest/upgrade_utils.v0.0.2/exec/checkoutsidecompilefiles ./build_all.sh >& build_all_fv3.log

./build_all.sh >& build_all_fv3.log


#################################
# ARW build
#################################

cd ../arw

#1st time only
if [ ! -e ../../fix/arw ]
then
./link_fix.sh
fi

# /gpfs/dell1/nco/ops/nwtest/upgrade_utils.v0.0.2/exec/checkoutsidecompilefiles ./build_hiresw.sh >& build_all_arw.log
./build_hiresw.sh >& build_all_arw.log
