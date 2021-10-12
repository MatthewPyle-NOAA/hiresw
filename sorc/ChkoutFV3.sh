#! /bin/sh

#################################
# FV3 build
#################################

# 1st time only
if [ ! -e fv3/hireswfv3_utils.fd ]
then
./manage_externals/checkout_externals
else
echo "already ran checkout_externals"
fi

cd fv3

# 1st time only
if [ ! -e ../../fix/fv3 ]
then
./link_fix.sh
fi

# just in case - needed for FV3 build
#module load python/3.8.6

#./build_all.sh >& build_all_fv3.log

#################################
# ARW build
#################################

cd ../arw

#1st time only
if [ ! -e ../../fix/arw ]
then
./link_fix.sh
fi

#./build_hiresw.sh >& build_all_arw.log
