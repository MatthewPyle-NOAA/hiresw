#! /bin/ksh

################################################################################
####  UNIX Script Documentation Block
#                      .                                             .
# Script name:            hiresw_prdgen_oldgrid.sh
# Script description:     Runs prdgen for the legacy (old) grid distributed to AWIPS
#
#
# Author:        Matthew Pyle       Org: NP22         Date: 2014-02-11
#
# Abstract:      Runs prdgen for a specific hour, domain, and model, horizontally interpolating
#                native GRIB output onto the legacy 5 km grids
#
# Script history log:
# 2013-08-01  Matthew Pyle - Original script for parallel
# 2014-02-11  Matthew Pyle - Added brief docblock


set -x

fhr=$1
DOMIN_SMALL=$2
CYC=${3}
model=$4
subpiece=$5

compress="c3 -set_bitmap 1"
reflag=1

mkdir -p ${DATA}/prdgen_5km_${subpiece}/${fhr}
cd ${DATA}/prdgen_5km_${subpiece}/${fhr}

DOMIN=${DOMIN_SMALL}${model}

modelout=$model
if [ $model = "arw" ]
then
modelout="arw"
reflag=0
# modelout="em"
fi

DOMOUT=${DOMIN_SMALL}${modelout}

if [ $DOMIN = "conusarw" ]
then
  filenamthree="wrf.EMEAST05"
  IM=884
  JM=614
elif [ $DOMIN = "akarw" -o $DOMIN = "akmem2arw" ]
then
  filenamthree="wrf.EMAK05"
  IM=825
  JM=603
  wgt=ak
  reg="20 6 0 0 0 0 0 0 825 603 44800000 -174500000 136 60000000 -150000000 5000000 5000000 0 64"
  wgrib2def="nps:210:60 185.5:825:5000 44.8:603:5000"
elif [ $DOMIN = "hiarw" -o $DOMIN = "himem2arw" ]
then
  filenamthree="wrf.EMHI05"
  IM=223
  JM=170
  wgt=hi
#  reg="0 6 0 0 0 0 0 0 223 170 0 0 16400000 -162350000 136 24005000 -152360000 45000 45000 64"
  reg="0 6 0 0 0 0 0 0 223 170 0 0 16400000 197650000 136 24005000 207640000 45000 45000 64"
  wgrib2def="latlon 197.65:223:.045 16.4:170:.045"
elif [ $DOMIN = "prarw" -o $DOMIN = "prmem2arw" ]
then
  filenamthree="wrf.EMPR05"
  IM=340
  JM=208
  wgt=pr
#  reg="0 6 0 0 0 0 0 0 340 208 0 0 13500000 -76590000 136 22815000 -61335000 45000 45000 64"
  reg="0 6 0 0 0 0 0 0 340 208 0 0 13500000 283410000 136 22815000 298665000 45000 45000 64"
  wgrib2def="latlon 283.41:340:.045 13.5:208:.045"
elif [ $DOMIN = "guamarw" ]
then
  filenamthree="wrf.EMGU05"
  IM=223
  JM=170
  wgt=guam
  reg="0 6 0 0 0 0 0 0 223 170 0 0 11700000 141000000 136 19305000 150990000 45000 45000 64"
  wgrib2def="latlon 141.0:223:.045 11.7:170:.045"
fi

filedir=$DATA

export fhr
export tmmark=tm00

###############################################################
###############################################################
###############################################################

#
# make GRIB file with pressure data every 25 mb for EMC's FVS
# verification

if [ $DOMIN_SMALL = "ak" -o $DOMIN_SMALL = "akmem2" ]
then
cp $PARMhiresw/hiresw_awpreg.txt_${subpiece} hiresw_grid_extract.txt
else
cp $PARMhiresw/hiresw_awpreg.txt hiresw_grid_extract.txt
fi

if [ $DOMIN_SMALL = "conus" ]
then

if [ $fhr -eq 00 ]
then
INPUT_DATA=$INPUT_DATA_EVEN
elif [ $fhr%2 -eq 0 ]
then
INPUT_DATA=$INPUT_DATA_EVEN
else
INPUT_DATA=$INPUT_DATA_ODD
fi

fi


looplim=90
loop=1
while [ $loop -le $looplim ]
do
 echo in while
 if [ -s $INPUT_DATA/postdone${fhr} ]
 then
   break
 else
   loop=$((loop+1))
   sleep 20
 fi
 if [ $loop -ge $looplim ]
   then
   msg="FATAL ERROR: ABORTING after 30 minutes of waiting for $INPUT_DATA/postdone${fhr}"
   err_exit $msg
 fi
done


### extract just needed items

$WGRIB2 $INPUT_DATA/WRFPRS${fhr}.tm00 | grep -F -f hiresw_grid_extract.txt | $WGRIB2 -i -grib inputs.grb $INPUT_DATA/WRFPRS${fhr}.tm00

$WGRIB2 inputs.grb -set_grib_type ${compress} -new_grid_vectors UGRD:VGRD -new_grid_winds grid -new_grid_interpolation neighbor -new_grid ${wgrib2def} ${filenamthree}${fhr}.tm00_bilin

if [ $subpiece =  "0"  -o $subpiece =  "1" ]
then
$WGRIB2 $INPUT_DATA/WRFPRS${fhr}.tm00 -match ":(APCP|WEASD):" -grib inputs_budget.grb
$WGRIB2 $INPUT_DATA/WRFPRS${fhr}.tm00 -match ":(HINDEX|TSOIL|SOILW|CSNOW|CICEP|CFRZR|CRAIN|RETOP|REFD|LTNG|MAXREF):" -grib nn.grb
$WGRIB2 $INPUT_DATA/WRFPRS${fhr}.tm00 -match "HGT:cloud ceiling:" -grib ceiling.grb
$WGRIB2 $INPUT_DATA/WRFPRS${fhr}.tm00 -match ":MDIV:30-0 mb above ground:" -grib mconv.grb
cat nn.grb ceiling.grb mconv.grb > inputs_nn.grb

$WGRIB2 inputs_nn.grb -set_grib_type ${compress} -new_grid_winds grid -new_grid_interpolation neighbor -new_grid ${wgrib2def} ${filenamthree}${fhr}.tm00_nn
$WGRIB2 inputs_budget.grb -set_grib_type ${compress} -new_grid_winds grid -new_grid_interpolation budget -new_grid ${wgrib2def} ${filenamthree}${fhr}.tm00_budget
fi

if [ $subpiece =  "0"  -o $subpiece =  "1" ]
then
cat ${filenamthree}${fhr}.tm00_bilin ${filenamthree}${fhr}.tm00_nn ${filenamthree}${fhr}.tm00_budget > ${filenamthree}${fhr}.tm00
cp ${filenamthree}${fhr}.tm00 ../
else
mv ${filenamthree}${fhr}.tm00_bilin ${filenamthree}${fhr}.tm00
cp ${filenamthree}${fhr}.tm00 ../
fi


export err=$?; err_chk

###############################################################
###############################################################


cd ../

# compute precip buckets

threehrprev=`expr $fhr - 3`
sixhrprev=`expr $fhr - 6`
onehrprev=`expr $fhr - 1`

if [ $threehrprev -lt 10 ]
then
threehrprev=0$threehrprev
fi

if [ $sixhrprev -lt 10 ]
then
sixhrprev=0$sixhrprev
fi

if [ $onehrprev -lt 10 ]
then
onehrprev=0$onehrprev
fi

echo "to f00 test"

if [ $fhr -eq 00 ]
then
echo "inside f00 test"

      cp ${filenamthree}${fhr}.tm00 $DATA/hiresw.t${CYC}z.${model}_5km.f${fhr}.${DOMIN_SMALL}.grib2_${subpiece}

else

if [ $subpiece =  "0"  -o $subpiece =  "1" ]
then

### do precip buckets if model is ARW

looplim=90
loop=1
while [ $loop -le $looplim ]
do
 echo in while
 if [ -s $DATA/prdgen_5km_${subpiece}/$filenamthree$onehrprev.tm00 ]
 then
   break
 else
   loop=$((loop+1))
   sleep 20
 fi
 if [ $loop -ge $looplim ]
   then
   msg="FATAL ERROR: ABORTING after 30 minutes of waiting for $DATA/prdgen_5km_${subpiece}/$filenamthree$onehrprev.tm00"
   err_exit $msg
 fi
done


  rm PCP1HR${fhr}.tm00
  rm input.card.${fhr}
  echo "$DATA/prdgen_5km_${subpiece}" > input.card.${fhr}
  echo $filenamthree >> input.card.${fhr}
  echo $onehrprev >> input.card.${fhr}
  echo $fhr >> input.card.${fhr}
  echo $reflag >> input.card.${fhr}
  echo $IM $JM >> input.card.${fhr}

 export pgm=hiresw_bucket
 $EXEChiresw/hiresw_bucket < input.card.${fhr} >> $pgmout 2>errfile
 export err=$?; err_chk

mv errfile errfile_${fhr}

  if [ $model = "arw" ] ; then

  if [ $fhr%3 -eq 0 ]
  then

looplim=90
loop=1
while [ $loop -le $looplim ]
do
 echo in while
 if [ -s $DATA/prdgen_5km_${subpiece}/$filenamthree$threehrprev.tm00 ]
 then
   break
 else
   loop=$((loop+1))
   sleep 10
 fi
 if [ $loop -ge $looplim ]
   then
   msg="FATAL ERROR: ABORTING after 15 minutes of waiting for $DATA/prdgen_5km_${subpiece}/$filenamthree$threehrprev.tm0"
   err_exit $msg
 fi
done

  rm PCP3HR${fhr}.tm00
  rm input.card.${fhr}
  echo "$DATA/prdgen_5km_${subpiece}" > input.card.${fhr}
  echo $filenamthree >> input.card.${fhr}
  echo $threehrprev >> input.card.${fhr}
  echo $fhr >> input.card.${fhr}
  echo $reflag >> input.card.${fhr}
  echo $IM $JM >> input.card.${fhr}

 export pgm=hiresw_bucket
 $EXEChiresw/hiresw_bucket < input.card.${fhr} >> $pgmout 2>errfile
 export err=$?; err_chk
mv errfile errfile_${fhr}_3hrly

  if [ $fhr -ne 3 ]
  then
    cat ${filenamthree}${fhr}.tm00 PCP1HR${fhr}.tm00 PCP3HR${fhr}.tm00 > hiresw.t${CYC}z.${model}_5km.f${fhr}.${DOMIN_SMALL}.grib2
  else
    cat ${filenamthree}${fhr}.tm00 PCP1HR${fhr}.tm00 > hiresw.t${CYC}z.${model}_5km.f${fhr}.${DOMIN_SMALL}.grib2
  fi

  fi # ARW 3 h 

  if [ $fhr%3 -ne 0 ] 
  then

  if [ $fhr -ne 1 ]
  then
    cat ${filenamthree}${fhr}.tm00 PCP1HR${fhr}.tm00 > hiresw.t${CYC}z.${model}_5km.f${fhr}.${DOMIN_SMALL}.grib2
  else
    cp ${filenamthree}${fhr}.tm00 hiresw.t${CYC}z.${model}_5km.f${fhr}.${DOMIN_SMALL}.grib2
  fi

  fi

  else
## model = "nmm"

    if [ $fhr%3 -ne 1 ]
    then
   cat ${filenamthree}${fhr}.tm00  PCP1HR${fhr}.tm00  > hiresw.t${CYC}z.${model}_5km.f${fhr}.${DOMIN_SMALL}.grib2
    else
   cat ${filenamthree}${fhr}.tm00                     > hiresw.t${CYC}z.${model}_5km.f${fhr}.${DOMIN_SMALL}.grib2
    fi

  fi

  else

#  cp ${filenamthree}${fhr}.tm00 $DOMOUT.t${CYC}z.awpregf${fhr}
cp ${filenamthree}${fhr}.tm00  hiresw.t${CYC}z.${model}_5km.f${fhr}.${DOMIN_SMALL}.grib2

fi # subpiece1

###### DONE PRECIP BUCKET

    cp  hiresw.t${CYC}z.${model}_5km.f${fhr}.${DOMIN_SMALL}.grib2 \
              $DATA/hiresw.t${CYC}z.${model}_5km.f${fhr}.${DOMIN_SMALL}.grib2_${subpiece}

fi
