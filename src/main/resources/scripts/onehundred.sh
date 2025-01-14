#!/bin/sh

# Acknowledgment : XtremWeb-HEP is based on XtremWeb 1.8.0 by inria : http://www.xtremweb.net/
# Web            : http://www.xtremweb-hep.org
# 
#      This file is part of XtremWeb-HEP.
#
# Copyright [2018] [CNRS] Oleg Lodygensky
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#



############################################################
# Date    : 21 janvier 2010
# Purpose : This script helps to test the platform
# Usage   : onehundred.sh aDataFile [jobsPerRun] [sleep]
############################################################

PRG=$0

############################################################
# Let first reach "real" file through symbolic links, if any
############################################################

while [ -h "$PRG" ]; do
    ls=`ls -ld "$PRG"`
    link=`expr "$ls" : '^.*-> \(.*\)$' 2>/dev/null`
    if expr "$link" : '^/' 2> /dev/null >/dev/null; then
        PRG="$link"
    else
        PRG="`dirname $PRG`/$link"
    fi
done

PROGDIR=`dirname $PRG`
PROGNAME=`basename $0`


######################################################
# Main
######################################################


[ "XYZ$X509_USER_PROXY" = "XYZ" ] &&  echo "WARNING : Env variable X509_USER_PROXY is not set"


PROG=$PROGNAME
#ROOTDIR="$PROGDIR/.."

currentDir=`pwd`
cd $PROGDIR
SCRIPTDIR=`pwd`
ROOTDIR=`pwd`/..
cd $currentDir

if [ "XYZ$1" = "XYZ" ] ; then
    echo "Usage : $PROG file"
    exit 1
fi

SLEEPING=300
MAXJOBSPERRUN=100

[ "XYZ$2" != "XYZ" ]  && MAXJOBSPERRUN=$2
[ "XYZ$3" != "XYZ" ]  && SLEEPING=$3


DATA=$1
if [ ! -f $DATA ] ; then
    echo "ERROR : can't find $DATA"
    exit 1
fi

DATADIR=`dirname $DATA`
DATANAME=`basename $DATA`
DATAPATH=$DATADIR/$DATANAME


BINDIR=$ROOTDIR/bin
CFGDIR=$ROOTDIR/conf

TMP=/tmp/onehundred
mkdir $TMP

cd $TMP


SUBMITMACRO=$TMP/submit.macro
STATUSMACRO=$TMP/status.macro
RMMACRO=$TMP/rm.macro
WORKUIDS=$TMP/workuids.txt
WORKSXML=$TMP/works.xml
DATAUIDS=$TMP/datauids.txt

touch $WORKUIDS
touch $DATAUIDS


$BINDIR/xwversion 2>&1 /dev/null
if [ $? -ne 0 ] ; then
	echo "ERROR : Can't connect"
	exit 1
fi

# remove any previous datas and works
rm -f $RMMACRO
touch $RMMACRO

cat $DATAUIDS | sed "s/^xw:\(.*\)/--xwremove xw:\1/" >> $RMMACRO
cat $WORKUIDS | sed "s/^xw:\(.*\)/--xwremove xw:\1/" >> $RMMACRO
$BINDIR/xwrm --xwmacro $RMMACRO
rm -f $RMMACRO


rm -f $DATAUIDS
rm -f $WORKUIDS
touch $DATAUIDS
touch $WORKUIDS


echo "$BINDIR/xwsenddata MyData $DATAPATH"
DATAUID=`$BINDIR/xwsenddata MyData $DATAPATH`
echo $DATAUID >> $DATAUIDS


JOBSPERRUN=$MAXJOBSPERRUN

while [ 1 ] ; do

    rm -f $SUBMITMACRO
    rm -f $WORKUIDS

    my $d;
    chomp($d=`date "+%m/%d/%y %H:%M:%S"`);
    echo "$d [INFO] : submitting $JOBSPERRUN"

    if [ $JOBSPERRUN -gt 0 ] ; then

	for (( i = 0 ; i < $JOBSPERRUN; i++ )) ; do
	    echo "--xwsendwork DART -infile DartAudio.wav -outfile DART-10-1.txt -nofreqpoints 10 -noharmonics 1 -fft_window Hamming --xwenv $DATAUID" >> $SUBMITMACRO
	done

	$BINDIR/xwsubmit --xwmacro $SUBMITMACRO | grep -E '^xw://' > $WORKUIDS
	cat $WORKUIDS | sed "s/^xw:\(.*\)/--xwget --xwdownload xw:\1/" > $STATUSMACRO

    fi


    echo '$BINDIR/xwresults --xwmacro $STATUSMACRO | grep -E "COMPLETED|ERROR" | wc -l'
    $BINDIR/xwresults --xwmacro $STATUSMACRO | grep -E "COMPLETED|ERROR" > $WORKSXML
    COMPLETEDS=`cat  $WORKSXML | wc -l`
    rm -f $TMP/*zip
    rm -f $TMP/*.txt

    rm -f $RMMACRO
    touch $RMMACRO
    cat $WORKSXML | sed  "s/^\(.*\) uid\=\"\(.*\)\".*$/--xwremove \2/"| cut -d '"' -f 1 >> $RMMACRO
    $BINDIR/xwrm --xwmacro $RMMACRO
    rm -f $RMMACRO

    echo "INFO : completeds $COMPLETEDS"

    if [ $COMPLETEDS -eq 0 ] ; then
	JOBSPERRUN=0
    else
	JOBSPERRUN=$COMPLETEDS
    fi

    echo "INFO : sleeping $SLEEPING"

    sleep $SLEEPING

done
