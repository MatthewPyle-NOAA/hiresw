#!/bin/ksh
################################################################################
####  UNIX Script Documentation Block
#                      .                                             .
# Script name:         exhiresw_metgrid.sh.ecf
# Script description:  Horizontal interpolation script for HiresW WRF-ARW and NMMB members
#
# Author:        Eric Rogers       Org: NP22         Date: 2004-07-02
#
# Abstract: The script takes output from the preceding UNGRIB job and interpolates meteorological
#           fields onto the model domain.
#
# Script history log:
# 2003-11-01  Matt Pyle - Original script for parallel
# 2004-07-02  Eric Rogers - Preliminary modifications for production.
# 2004-10-01  Eric Rogers - Modified to run special real executable for Alaska NMM
# 2007-04-09  Matthew Pyle - Modified to run WPS rather than wrfsi
# 2009-09-24  Shawna Cokley - Streamlines way script obtains date information -
#                             pulls from $PDY rather than copying a file to the working directory
# 2013-10-01  Matthew Pyle - Split out from prelim job

set -x

msg="JOB $job FOR WRF NEST=${NEST}${MODEL} HAS BEGUN"
postmsg  "$msg"

RUNLOC=${NEST}${MODEL}

export CYCLE=$PDY$cyc
echo "export CYCLE=$CYCLE" >> $COMOUT/hiresw.t${cyc}z.${RUNLOC}.envir.sh


#########################################################
# RUN MULTIPLE METGRID STEPS USING POE
#########################################################

# Create a script to be poe'd
cd $DATA
rm -rf poescript


# Rename metgrid files with /com type names
export send=1

echo "#!/bin/bash" > poe.a
echo "$USHhiresw/hiresw_wps_metgrid_gen.sh $NEST $cyc 00 03 1 $MODEL $send" >> poe.a

echo "#!/bin/bash" > poe.aa
echo "$USHhiresw/hiresw_wps_metgrid_gen.sh $NEST $cyc 06 09 2 $MODEL $send" >> poe.aa

echo "#!/bin/bash" > poe.b
echo "$USHhiresw/hiresw_wps_metgrid_gen.sh $NEST $cyc 12 15 3 $MODEL $send" >> poe.b

echo "#!/bin/bash" > poe.bb
echo "$USHhiresw/hiresw_wps_metgrid_gen.sh $NEST $cyc 18 21 4 $MODEL $send" >> poe.bb

echo "#!/bin/bash" > poe.c
echo "$USHhiresw/hiresw_wps_metgrid_gen.sh $NEST $cyc 24 27 5 $MODEL $send" >> poe.c

echo "#!/bin/bash" > poe.cc
echo "$USHhiresw/hiresw_wps_metgrid_gen.sh $NEST $cyc 30 33 6 $MODEL $send" >> poe.cc

echo "#!/bin/bash" > poe.d
echo "$USHhiresw/hiresw_wps_metgrid_gen.sh $NEST $cyc 36 39 7 $MODEL $send" >> poe.d

echo "#!/bin/bash" > poe.dd
echo "$USHhiresw/hiresw_wps_metgrid_gen.sh $NEST $cyc 42 45 8 $MODEL $send" >> poe.dd

echo "#!/bin/bash" > poe.e
echo "$USHhiresw/hiresw_wps_metgrid_gen.sh $NEST $cyc 48 48 9 $MODEL $send" >> poe.e

chmod 775 poe.a poe.b poe.c poe.d poe.e
chmod 775 poe.aa poe.bb poe.cc poe.dd

./poe.a &
./poe.b &
./poe.c &
./poe.d &
./poe.e &
./poe.aa &
./poe.bb &
./poe.cc &
./poe.dd &
wait

export err=$?
err_chk

cat $DATA/metgrid.log.0000_* > $COMOUT/hiresw.t${cyc}z.${NEST}${MODEL}.metgrid.log

msg="JOB $job FOR WRF NEST=${NEST}${MODEL} HAS COMPLETED NORMALLY"
postmsg "$msg"
