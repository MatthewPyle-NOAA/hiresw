#!/bin/sh
############################################################################
# Script name:		exhiresw_make_bc.sh
# Script description:	Makes LBCs on fv3 stand-alone regional grid 
#                       using FV3GFS initial conditions.
# Script history log:
#   1) 2016-09-30       Fanglin Yang
#   2) 2017-02-08	Fanglin Yang and George Gayno
#			Use the new CHGRES George Gayno developed.
#   3) 2019-05-02	Ben Blake
#			Created exfv3cam_sar_chgres.sh script
#			from global_chgres_driver.sh
#
#   4) 2020-07-27       Matthew Pyle
#                       Error checking on normal completion.  Eliminates 
#                       linking to FIXsar directory within script
#
#   5) 2020-10-05       Matthew Pyle
#                       Changes for GFSv16 and processing netCDF files

#   6) 2021-02-01       Matthew Pyle
#                       Revises file names for LBC output
############################################################################
set -ax

# gtype = regional
echo "creating standalone regional BCs"
export ntiles=1
export TILE_NUM=7

#
# set the links to use the 4 halo grid and orog files
# these are necessary for creating the boundary data

#
# create namelist and run chgres cube
#
cp ${CHGRESEXEC} .

hour=${fhr}
gfs_hour=`expr $hour + 6`

rem=$((gfs_hour%6))
if [ $rem -ne 0  ]; then
  gfs_hour_t=`expr $gfs_hour + 3`
else
  gfs_hour_t=$gfs_hour
fi

if [ $gfs_hour -lt 10 ]; then
  gfs_hour='0'$gfs_hour
fi

if [ $gfs_hour_t -lt 10 ]; then
  gfs_hour_t='0'$gfs_hour_t
fi

if [ $hour -lt 10 ]; then
  hour_name='0'$hour
elif [ $hour -lt 100 ]; then
  hour_name='0'$hour
else
  hour_name=$hour
fi


echo gfs_hour $gfs_hour
echo hour_name $hour_name

mkdir -p ${hour_name}
cd ${hour_name}

rm ./*

export SDATE=`$NDATE ${hour_name} $CDATE`
python $UTILush/getbest_FV3GFS.py  -d $COMINgfs -v $SDATE -t ${gfs_hour_t} -s ${gfs_hour} -o tmp.atm --exact=yes --gfs_nemsio=no --gfs_netcdf=yes  --filetype=atm
ATMDIR=`head -n1 tmp.atm`
ATMFILE=`tail -n1 tmp.atm`

python $UTILush/getbest_FV3GFS.py  -d $COMINgfs -v $CDATE -t 72 -o tmp.sfc --exact=yes --gfs_nemsio=no --gfs_netcdf=yes  --filetype=sfc
SFCFILE=`tail -n1 tmp.sfc`

echo "&config" > fort.41
echo ' mosaic_file_target_grid="_FIXsar_/_CASE__mosaic.nc"' >> fort.41
echo ' fix_dir_target_grid="_FIXsar_"' >> fort.41
echo ' orog_dir_target_grid="_FIXsar_"' >> fort.41
echo ' orog_files_target_grid="_CASE__oro_data.tile7.halo4.nc"' >> fort.41 
echo ' vcoord_file_target_grid="_FIXam_/global_hyblev.l_LEVS_.txt"' >> fort.41 
echo ' mosaic_file_input_grid="NULL"' >> fort.41
echo ' orog_dir_input_grid="NULL"' >> fort.41
echo ' orog_files_input_grid="NULL"' >> fort.41
echo ' data_dir_input_grid="_ATMDIR_"' >> fort.41
echo ' atm_files_input_grid="_ATMFILE_"' >> fort.41
echo ' sfc_files_input_grid="_SFCFILE_"' >> fort.41
echo " cycle_mon=$month" >> fort.41
echo " cycle_day=$day" >> fort.41
echo " cycle_hour=$cyc" >> fort.41
echo " convert_atm=.true." >> fort.41
echo " convert_sfc=.false." >> fort.41
echo " convert_nst=.false." >> fort.41
echo ' input_type="gaussian_netcdf"' >> fort.41
echo ' tracers="sphum","liq_wat","o3mr","ice_wat","rainwat","snowwat","graupel"' >> fort.41
echo ' tracers_input="spfh","clwmr","o3mr","icmr","rwmr","snmr","grle"' >> fort.41
echo " regional=${REGIONAL}" >> fort.41
echo " halo_bndy=${HALO}" >> fort.41
echo "/" >>  fort.41

cat fort.41 | sed s:_FIXsar_:${FIXsar}:g \
            | sed s:_CASE_:${CASE}:g \
            | sed s:_FIXam_:${FIXam}:g  \
            | sed s:_LEVS_:${LEVS}:g \
            | sed s:_ATMDIR_:${ATMDIR}:g \
            | sed s:_ATMFILE_:${ATMFILE}:g \
            | sed s:_SFCFILE_:${SFCFILE}:g \
            | sed s:_INIDIR_:${INIDIR}:g > fort.41.new

mv fort.41 fort.41.old
mv fort.41.new fort.41

# cd ../
# cd ${hour_name}

cp ${CHGRESEXEC} .
mpiexec -n ${NTASK} -ppn ${PTILE} ./hireswfv3_chgres_cube >& chgres_cube.${hour_name}.log 
cd ../

# save this stuff for the end of the job??

hruse=${hour_name}
mv ${hruse}/gfs.bndy.nc $COMOUT/hiresw.t${cyc}z.${NEST}${MODEL}.gfs_bndy.tile7.${hruse}.nc
err=$?
if [ $err -ne 0 ]
then
msg="FATAL ERROR: problem generating BC file"
err_exit $msg
fi

echo " poe scripts completed - normal finish for ${hour_name} "

exit 0
