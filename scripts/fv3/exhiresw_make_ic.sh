#!/bin/sh
############################################################################
# Script name:		exhiresw_make_ic.sh
# Script description:	Makes ICs on fv3 stand-alone regional grid 
#                       using FV3GFS initial conditions.
# Script history log:
#   1) 2016-09-30       Fanglin Yang
#   2) 2017-02-08	Fanglin Yang and George Gayno
#			Use the new CHGRES George Gayno developed.
#
#   3) 2019-05-02	Ben Blake
#			Created exfv3cam_sar_chgres.sh script
#			from global_chgres_driver.sh
#
#   4) 2021-02-01       Matthew Pyle
#                       Changes to attach domain/cycle specific information 
#                       to filenames when moving output.
############################################################################
set -ax

# gtype = regional
echo "creating standalone regional ICs"
export ntiles=1
export TILE_NUM=7

if [ $tmmark = tm00 ] ; then
  # input data is FV3GFS (ictype is 'pfv3gfs')
#tst  export ANLDIR=$INIDIR

   looplim=10
   loop=1
   ANLDIR=no
   SFCDIR=yes
   while [ $ANLDIR != $SFCDIR -a $loop -lt $looplim ]
   do
	   echo executing getbest_FV3GFS.py
   python $UTILush/getbest_FV3GFS.py  -d $COMINgfs -v $CDATE -t 72 -o tmp.atm --exact=yes --gfs_nemsio=no --gfs_netcdf=yes --filetype=atm
   	echo past getbest_FV3GFS.py 
   ANLDIR=`head -n1 tmp.atm`
   ATMFILE=`tail -n1 tmp.atm`

   python $UTILush/getbest_FV3GFS.py  -d $COMINgfs -v $CDATE -t 72 -o tmp.sfc --exact=yes --gfs_nemsio=no --gfs_netcdf=yes --filetype=sfc
   SFCDIR=`head -n1 tmp.sfc`
   SFCFILE=`tail -n1 tmp.sfc`

   echo ANLDIR is $ANLDIR
   echo SFCDIR is $SFCDIR
   sleep 10
   let loop=loop+1
   done
fi
if [ $tmmark = tm12 ] ; then
  # input data is FV3GFS (ictype is 'pfv3gfs')
  export ANLDIR=$INIDIRtm12
fi

#
# create namelist and run chgres cube
#
cp ${CHGRESEXEC} .
cat <<EOF >fort.41
&config
 mosaic_file_target_grid="$FIXsar/${CASE}_mosaic.nc"
 fix_dir_target_grid="$FIXsar"
 orog_dir_target_grid="$FIXsar"
 orog_files_target_grid="${CASE}_oro_data.tile7.halo4.nc"
 vcoord_file_target_grid="${FIXam}/global_hyblev.l${LEVS}.txt"
 mosaic_file_input_grid="NULL"
 orog_dir_input_grid="NULL"
 orog_files_input_grid="NULL"
 data_dir_input_grid="${ANLDIR}"
 atm_files_input_grid="${ATMFILE}"
 sfc_files_input_grid="${SFCFILE}"
 cycle_mon=$month
 cycle_day=$day
 cycle_hour=$cyc
 convert_atm=.true.
 convert_sfc=.true.
 convert_nst=.true.
 input_type="gaussian_netcdf"
 tracers="sphum","liq_wat","o3mr","ice_wat","rainwat","snowwat","graupel"
 tracers_input="spfh","clwmr","o3mr","icmr","rwmr","snmr","grle"
 regional=${REGIONAL}
 halo_bndy=${HALO}
/
EOF

mpiexec -n ${NTASK} -ppn ${PTILE} ./hireswfv3_chgres_cube
err=$?; err_chk

#
# move output files to save directory
#
mv gfs_ctrl.nc $COMOUT/hiresw.t${cyc}z.${NEST}${MODEL}.gfs_ctrl.nc
err=$?

if [ $err -ne 0 ]
then
msg="FATAL ERROR: problem in make_ic generating gfs_ctrl.nc file"
err_exit $msg
fi


mv gfs.bndy.nc $COMOUT/hiresw.t${cyc}z.${NEST}${MODEL}.gfs_bndy.tile7.000.nc
err=$?

if [ $err -ne 0 ]
then
msg="FATAL ERROR: problem in make_ic generating gfs.bndy.nc"
err_exit $msg
fi


mv out.atm.tile1.nc $COMOUT/hiresw.t${cyc}z.${NEST}${MODEL}.gfs_data.tile7.nc
err=$?

if [ $err -ne 0 ]
then
msg="FATAL ERROR: problem in make_ic generating out.atm.tile7.nc"
err_exit $msg
fi

mv out.sfc.tile1.nc $COMOUT/hiresw.t${cyc}z.${NEST}${MODEL}.sfc_data.tile7.nc
err=$?

if [ $err -ne 0 ]
then
msg="FATAL ERROR: problem in make_ic generating out.sfc.tile7.nc"
err_exit $msg
fi


exit 0
