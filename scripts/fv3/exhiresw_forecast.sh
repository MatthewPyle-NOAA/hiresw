#!/bin/sh
############################################################################
# Script name:		run_regional_gfdlmp.sh
# Script description:	Run the 3-km FV3 regional forecast over the CONUS
#			using the GFDL microphysics scheme.
# Script history log:
#   1) 2018-03-14	Eric Rogers
#			run_nest.tmp retrieved from Eric's run_it directory.	
#   2) 2018-04-03	Ben Blake
#                       Modified from Eric's run_nest.tmp script.
#   3) 2018-04-13	Ben Blake
#			Various settings moved to JFV3_FORECAST J-job
#   4) 2018-06-19       Ben Blake
#                       Adapted for stand-alone regional configuration
#   5) 2019-12-05       Matthew Pyle
#                       Modified to allow for midstream restarts in case of failure
############################################################################
set -x

ulimit -s unlimited
ulimit -a

resterr=1

restart_interval=6
FHMAX=60
export NHRS=60
hrlist="00 03 06 09 12 15 18 21 24 27 30 33 36 39 42 45 48 51 54 57 60"
model=fv3sar

cd $DATA


if [ -e RESTART ]
then
# make a count of available times and set resterr accordingly
files=`ls ${DATA}/RESTART/*00.sfc_data.nc | wc -l`

if [ $files -gt 1 ] 
then
resterr=0
else
resterr=1
echo "WARNING: Lack content in RESTART directory to restart properly, so will cold start"
mv ./err ./err_previous_run
fi

echo resterr is $resterr

else

mkdir -p INPUT RESTART

fi

RERUN="NO"

if [ $resterr -eq 0 ]
then
echo "have restart"
RESTART=1

# from GFS
# determine if restart IC exists to continue from a previous forecast
filecount=$(find ${DATA}/RESTART -type f | wc -l)
if [  $restart_interval -gt 0 -a  $FHMAX -gt $restart_interval -a $filecount -gt 5 ]; then
     echo into the key ifdef block
     SDATE=$($NDATE +$FHMAX $CDATE)
     EDATE=$($NDATE +$restart_interval $CDATE)

     while [ $SDATE -ge $EDATE ]; do
         PDYS=$(echo $SDATE | cut -c1-8)
         cycs=$(echo $SDATE | cut -c9-10)
	echo PDYS  $PDYS cycs $cycs
         flag1=${DATA}/RESTART/${PDYS}.${cycs}0000.coupler.res
         flag2=${DATA}/RESTART/coupler.res
         if [ -s $flag1 ]; then
              mv $flag1 ${flag1}.old
           if [ -s $flag2 ]; then mv $flag2 ${flag2}.old ;fi
            RERUN="YES"
            CDATE_RST=$($NDATE -$restart_interval $SDATE)
	echo set RERUN to $RERUN
	echo found CDATE_RST as $CDATE_RST
            break
        fi
        SDATE=$($NDATE -$restart_interval $SDATE)
	echo at test with SDATE $SDATE
	echo at test with EDATE $EDATE
    done
fi

    PDYT=$(echo $CDATE_RST | cut -c1-8)
    cyct=$(echo $CDATE_RST | cut -c9-10)

    echo PDYT $PDYT
    echo cyct $cyct

    
    for file in $DATA/RESTART/${PDYT}.${cyct}0000.*; do
      file2=$(echo $(basename $file))
      file2=$(echo $file2 | cut -d. -f3-)
      ln -sf $file $DATA/INPUT/$file2
      echo just generated  $DATA/INPUT/$file2
    done


# test new copy

cp $DATA/INPUT/sfc_data.nc $DATA/INPUT/sfc_data.tile7.nc


# end from GFS

else
echo "not restart"

for fhr in $hrlist
do
cp ${COMIN}/hiresw.t${cyc}z.${NEST}fv3.gfs_bndy.tile7.0${fhr}.nc INPUT/gfs_bndy.tile7.0${fhr}.nc
done

cp ${COMIN}/hiresw.t${cyc}z.${NEST}fv3.gfs_ctrl.nc INPUT/gfs_ctrl.nc
err1=$?
cp ${COMIN}/hiresw.t${cyc}z.${NEST}fv3.gfs_data.tile7.nc INPUT/gfs_data.tile7.nc
err2=$?
cp ${COMIN}/hiresw.t${cyc}z.${NEST}fv3.sfc_data.tile7.nc INPUT/sfc_data.tile7.nc
err3=$?

if [ $err1 -ne 0 -o $err2 -ne 0 -o $err3 -ne 0 ]
then
msg="FATAL ERROR:  Missing FV3 initial condition file(s)"
ls -l INPUT/gfs_ctrl.nc INPUT/gfs_data.tile7.nc INPUT/sfc_data.tile7.nc
err_exit $msg
fi


RESTART=0
fi

numbndy=`ls -l INPUT/gfs_bndy.tile7*.nc | wc -l`
let "numbndy_check=$NHRS/3+1"

if [ $tmmark = tm00 ] ; then
  if [ $numbndy -ne $numbndy_check ] ; then
    export err=13
    msg="FATAL ERROR: Don't have all BC files at tm00, abort run"
    err_exit $msg
  fi
fi

#---------------------------------------------- 
# Copy all the necessary fix files
#---------------------------------------------- 
cp $FIXam/global_solarconstant_noaa_an.txt            solarconstant_noaa_an.txt
cp $FIXam/ozprdlos_2015_new_sbuvO3_tclm15_nuchem.f77  global_o3prdlos.f77
cp $FIXam/global_h2o_pltc.f77                         global_h2oprdlos.f77
cp $FIXam/global_sfc_emissivity_idx.txt               sfc_emissivity_idx.txt
cp $FIXam/global_co2historicaldata_glob.txt           co2historicaldata_glob.txt
cp $FIXam/co2monthlycyc.txt                           co2monthlycyc.txt
cp $FIXam/global_climaeropac_global.txt               aerosol.dat

cp $FIXam/global_glacier.2x2.grb .
cp $FIXam/global_maxice.2x2.grb .
cp $FIXam/RTGSST.1982.2012.monthly.clim.grb .
cp $FIXam/global_snoclim.1.875.grb .
cp $FIXam/CFSR.SEAICE.1982.2012.monthly.clim.grb .
cp $FIXam/global_soilmgldas.t1534.3072.1536.grb .
cp $FIXam/seaice_newland.grb .
cp $FIXam/global_shdmin.0.144x0.144.grb .
cp $FIXam/global_shdmax.0.144x0.144.grb .

ln -sf $FIXsar/C768.maximum_snow_albedo.tile7.halo0.nc C768.maximum_snow_albedo.tile1.nc
ln -sf $FIXsar/C768.snowfree_albedo.tile7.halo0.nc C768.snowfree_albedo.tile1.nc
ln -sf $FIXsar/C768.slope_type.tile7.halo0.nc C768.slope_type.tile1.nc
ln -sf $FIXsar/C768.soil_type.tile7.halo0.nc C768.soil_type.tile1.nc
ln -sf $FIXsar/C768.vegetation_type.tile7.halo0.nc C768.vegetation_type.tile1.nc
ln -sf $FIXsar/C768.vegetation_greenness.tile7.halo0.nc C768.vegetation_greenness.tile1.nc
ln -sf $FIXsar/C768.substrate_temperature.tile7.halo0.nc C768.substrate_temperature.tile1.nc
ln -sf $FIXsar/C768.facsf.tile7.halo0.nc C768.facsf.tile1.nc


for file in `ls $FIXco2/global_co2historicaldata* ` ; do
  cp $file $(echo $(basename $file) |sed -e "s/global_//g")
done

#---------------------------------------------- 
# Copy tile data and orography for regional
#---------------------------------------------- 
ntiles=1
tile=7


if [ $RERUN = "NO" ]
then
cp $FIXsar/${CASE}_grid.tile${tile}.halo3.nc INPUT/.
cp $FIXsar/${CASE}_grid.tile${tile}.halo4.nc INPUT/.
cp $FIXsar/${CASE}_oro_data.tile${tile}.halo0.nc INPUT/.
cp $FIXsar/${CASE}_oro_data.tile${tile}.halo4.nc INPUT/.
cp $FIXsar/${CASE}_mosaic.nc INPUT/.
  
cd INPUT
ln -sf ${CASE}_mosaic.nc grid_spec.nc
ln -sf ${CASE}_grid.tile7.halo3.nc ${CASE}_grid.tile7.nc
ln -sf ${CASE}_grid.tile7.halo4.nc grid.tile7.halo4.nc
ln -sf ${CASE}_oro_data.tile7.halo0.nc oro_data.nc
ln -sf ${CASE}_oro_data.tile7.halo0.nc oro_data.tile7.nc
ln -sf ${CASE}_oro_data.tile7.halo4.nc oro_data.tile7.halo4.nc
# Initial Conditions are needed for SAR but not SAR-DA
ln -sf sfc_data.tile7.nc sfc_data.nc
ln -sf gfs_data.tile7.nc gfs_data.nc

cd ..
fi

#-------------------------------------------------------------------
# Copy or set up files data_table, diag_table, field_table,
#   input.nml, input_nest02.nml, model_configure, and nems.configure
#-------------------------------------------------------------------
CCPP=${CCPP:-"true"}
CCPP_SUITE=${CCPP_SUITE:-"FV3_GFS_2017_gfdlmp_regional"}

if [ $tmmark = tm00 ] ; then
# Free forecast with DA (warm start)
  if [ $model = fv3sar_da ] ; then
    cp ${PARMfv3}/input_fv3_da.nml input.nml 
# Free forecast without DA (cold start)
  elif [ $model = fv3sar ] ; then 

    if [ $CCPP  = true ] || [ $CCPP = TRUE ] ; then
      cp ${PARMfv3}/input_fv3_${NEST}ccpp.nml_inp input.nml.tmp
      cat input.nml.tmp | sed s/CCPP_SUITE/\'$CCPP_SUITE\'/ >  input.nml_inp

      if [ $RESTART -eq 1 ]
      then

       cat input.nml_inp | \
       sed s:_MAKENH_:.F.: | \
       sed s:_NAINIT_:0: | \
       sed s:_NGGPSIC_:.F.: | \
       sed s:_EXTERNALIC_:.F.: | \
       sed s:_NSTF_NAME_:2,0,0,0,0: | \
       sed s:_MOUNTAIN_:.T.: | \
       sed s:_WARMSTART_:.T.:  > input.nml
      else
       cat input.nml_inp | \
       sed s:_MAKENH_:.T.: | \
       sed s:_NAINIT_:1: | \
       sed s:_NGGPSIC_:.T.: | \
       sed s:_EXTERNALIC_:.T.: | \
       sed s:_NSTF_NAME_:2,0,0,0,0: | \
       sed s:_MOUNTAIN_:.F.: | \
       sed s:_WARMSTART_:.F.:  > input.nml
       fi

      if [ ! -e input.nml ] ; then
         echo "FATAL ERROR: no input_fv3_${NEST}ccpp.nml_inp in PARMfv3 directory.  Create one!"
         exit
      else
        mv input.nml input.nml.tmp
        cat input.nml.tmp | \
            sed s/_TASK_X_/${TASK_X}/ | sed s/_TASK_Y_/${TASK_Y}/  >  input.nml
      fi

    else

      if [ $RESTART -eq 1 ]
      then

       cat ${PARMfv3}/input_fv3_${NEST}.nml_inp | \
       sed s:_MAKENH_:.F.: | \
       sed s:_NAINIT_:0: | \
       sed s:_NGGPSIC_:.F.: | \
       sed s:_EXTERNALIC_:.F.: | \
       sed s:_NSTF_NAME_:2,0,0,0,0: | \
       sed s:_MOUNTAIN_:.T.: | \
       sed s:_WARMSTART_:.T.:  > input.nml
      else
       cat ${PARMfv3}/input_fv3_${NEST}.nml_inp | \
       sed s:_MAKENH_:.T.: | \
       sed s:_NAINIT_:1: | \
       sed s:_NGGPSIC_:.T.: | \
       sed s:_EXTERNALIC_:.T.: | \
       sed s:_NSTF_NAME_:2,0,0,0,0: | \
       sed s:_MOUNTAIN_:.F.: | \
       sed s:_WARMSTART_:.F.:  > input.nml
       fi

      if [ ! -e input.nml ] ; then
         echo "FATAL ERROR: no input_fv3_${NEST}.nml in PARMfv3 directory.  Create one!"
         exit
      else
        mv input.nml input.nml.tmp
        cat input.nml.tmp | \
            sed s/_TASK_X_/${TASK_X}/ | sed s/_TASK_Y_/${TASK_Y}/  >  input.nml
      fi
    fi
  fi
  cp ${PARMfv3}/model_configure_fv3.tmp_${NEST}_ccpp model_configure.tmp
else

echo "FATAL ERROR: tmmark not set as tm00 - this version of script requires tmmark=tm00"
exit

fi

cp ${PARMfv3}/d* .
cp ${PARMfv3}/field_table .
cp ${PARMfv3}/nems.configure .

if [ $CCPP  = true ] || [ $CCPP = TRUE ] ; then
   if [ -f "${PARMfv3}/field_table_ccpp" ] ; then
    cp -f ${PARMfv3}/field_table_ccpp field_table
   fi
fi

yr=`echo $CYCLEanl | cut -c1-4`
mn=`echo $CYCLEanl | cut -c5-6`
dy=`echo $CYCLEanl | cut -c7-8`
hr=`echo $CYCLEanl | cut -c9-10`

if [ $tmmark = tm00 ] ; then
  NFCSTHRS=$NHRS
  NRST=06
else
  NFCSTHRS=$NHRSda
  NRST=01
fi

cat > temp << !
${yr}${mn}${dy}.${hr}Z.${CASE}.32bit.non-hydro
$yr $mn $dy $hr 0 0
!

cat temp diag_table.tmp > diag_table

export OMP_THREADS=1
export OMP_NUM_THREADS=1

cat model_configure.tmp | sed s/NTASKS/$TOTAL_TASKS/ | sed s/YR/$yr/ | \
    sed s/MN/$mn/ | sed s/DY/$dy/ | sed s/H_R/$hr/ | \
#tmp    sed s/NHRS/$NFCSTHRS/ | sed s/NTHRD/$OMP_NUM_THREADS/ | \
    sed s/NHRS/$NFCSTHRS/ | sed s/NTHRD/$OMP_THREADS/ | \
    sed s/NCNODE/$NCNODE/ | sed s/NRESTART/$NRST/ | \
    sed s/_WG_/${WG}/ | sed s/_WTPG_/${WTPG}/  >  model_configure

#----------------------------------------- 
# Run the forecast
#-----------------------------------------
export pgm=hireswfv3_forecast
. prep_step

startmsg

# export MKL_CBWR=AVX2

echo APRUNC is $APRUNC

${APRUNC} $EXECfv3/hireswfv3_forecast >$pgmout 2>err
export err=$?;err_chk

if [ $err -eq 0 -a $NEST = 'guam' ] ; then
  cd RESTART
  fhrs="06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24"

  ftypes="coupler.res fv_core.res.nc fv_core.res.tile1.nc \
	  fv_srf_wnd.res.tile1.nc fv_tracer.res.tile1.nc \
	  sfc_data.nc phy_data.nc" 
  for fhr in $fhrs
  do

   newdate=`$NDATE +$fhr ${PDY}${cyc}`
   VDATE=`echo $newdate | cut -c1-8`
   VTIME=`echo $newdate | cut -c9-10`

   for ftype in $ftypes
   do
   cp ${VDATE}.${VTIME}0000.${ftype}  \
	  $COMOUTrestart/hiresw.t${cyc}z.guamfv3.${VDATE}.${VTIME}0000.${ftype}
   done

  done
fi

exit
