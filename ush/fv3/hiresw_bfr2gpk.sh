#!/bin/sh -l
#########################################################################
#									#
# Script: hiresw_bfr2gpk						#
#									#
#  This script reads HIRESW BUFR output and unpacks it into GEMPAK	#
#  surface and sounding data files.					#
#									#
# Log:									#
# M. Pyle/EMC           06/2022  adapt for HIRESW                       #
# G. Manikin/EMC        5/30/14  adapt for HRRR                         #
#########################################################################  
set -x

#  Go to a working directory.

cd $DATA
cp $GEMPAKhiresw/fix/snhiresw.prm snhiresw.prm
err1=$?
cp $GEMPAKhiresw/fix/sfhiresw.prm_aux sfhiresw.prm_aux
err2=$?
cp $GEMPAKhiresw/fix/sfhiresw.prm sfhiresw.prm
err3=$?

if [ $err1 -ne 0 -o $err2 -ne 0 -o $err3 -ne 0 ]
then
	msg="FATAL ERROR: Missing GEMPAK BUFR tables"
	err_exit $msg
fi

#  Set input file name.

INFILE=$COMOUT/hiresw.t${cyc}z.${NEST}${MODEL}.class1.bufr
export INFILE

outfilbase=hiresw_${NEST}${MODEL}_${PDY}${cyc}

namsnd << EOF > /dev/null
SNBUFR   = $INFILE
SNOUTF   = ${outfilbase}.snd
SFOUTF   = ${outfilbase}.sfc+
SNPRMF   = snhiresw.prm
SFPRMF   = sfhiresw.prm
TIMSTN   = 61/1600
r

exit
EOF

/bin/rm *.nts

snd=${outfilbase}.snd
sfc=${outfilbase}.sfc
aux=${outfilbase}.sfc_aux

cp $snd $COMOUT/gempak/.$snd
cp $sfc $COMOUT/gempak/.$sfc
cp $aux $COMOUT/gempak/.$aux

mv $COMOUT/gempak/.$snd $COMOUT/gempak/$snd
mv $COMOUT/gempak/.$sfc $COMOUT/gempak/$sfc
mv $COMOUT/gempak/.$aux $COMOUT/gempak/$aux

if [ "$SENDDBN" = 'YES' ] ; then
  $SIPHONROOT/bin/dbn_alert MODEL HIRESW_GEMPAK $job $COMOUT/gempak/$sfc
  $SIPHONROOT/bin/dbn_alert MODEL HIRESW_GEMPAK $job $COMOUT/gempak/$aux
  $SIPHONROOT/bin/dbn_alert MODEL HIRESW_GEMPAK $job $COMOUT/gempak/$snd
fi
