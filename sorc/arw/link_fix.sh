#!/bin/sh
set -xeu

LINK="cp -rp"
pwd=$(pwd -P)

FIX_DIR="/lfs/h2/emc/lam/noscrub/Matthew.Pyle/fix_guamhiresw_rrfsera"

mkdir -p ${pwd}/../../fix/arw
cd ${pwd}/../../fix/arw                || exit 8

${LINK} $FIX_DIR/fix_arw/* .
${LINK} $FIX_DIR/wrflibs  ${pwd}/hiresw_wrfbufr.fd/

exit
