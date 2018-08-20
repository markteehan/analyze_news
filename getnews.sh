#!/bin/bash

P=`pwd`
HOST=`hostname`
D=~/Downloads/gdelt_15mins
MIN=`date -u +"%M"`

yell() { echo "$0: $*" >&2; }
die() { yell "$*"; exit 111; }
try() { "$@" || die "cannot $*"; }

setupdir()
{
  if [ -d $D ]
  then
      #echo "(I) .. $D already exists .. continuing"
      a=a
  else
      mkdir $D
      RET=$?
      if [ "$RET" -eq "0" ]
      then
        echo "(I) .. created download directory $D "
      else
        echo "(E) .. unable to create download directory $D  - please check and re-run"
        die
      fi
  fi
}


function get_last_utc_interval()
{
# round the current minute down to the last quarter-hour.
NOW_MIN=`date +"%M"`
  if (( 10#$NOW_MIN >= "00" && 10#$NOW_MIN < "15" ));  then LPAD_I=`printf 00`
elif (( 10#$NOW_MIN >= "15" && 10#$NOW_MIN < "30" ));  then LPAD_I=`printf 15`
elif (( 10#$NOW_MIN >= "30" && 10#$NOW_MIN < "45" ));  then LPAD_I=`printf 30`
elif (( 10#$NOW_MIN >= "45" && 10#$NOW_MIN <= "59" )); then LPAD_I=`printf 45`
fi
echo `date -u +"%Y%m%d%H"`${LPAD_I}00
exit
}

get_latest_file()
{

DT=$(get_last_utc_interval)
TARGET_FILE=`basename ${DT}.export.csv`
if [ -f ${D}/$TARGET_FILE ];
then
  echo;echo;echo;echo "(I) the latest file ($TARGET_FILE) has already been loaded. Re-run this after the next quarter-hour."
else
  cd $D
  wgetfile http://data.gdeltproject.org/gdeltv2/${DT}.export.CSV.zip DONT_RETRY
  if [ -f `basename ${DT}.export.CSV.zip` ];
    then
      rm -f ${DT}.export.CSV
      unzip -D -qq ${DT}.export.CSV.zip
      rm ${DT}.export.CSV.zip
      export F=${D}/${DT}.export.csv
      mv ${DT}.export.CSV ${F}
      STORIES=`cat $F|wc -l`
      echo "(I) downloaded $STORIES news events from file $F"
      #create_kafka_topic GDELT_EVENT02
      #load_kafka_topic GDELT_EVENT02 ${F} $KAFKA_HOST
      #TARGET_ROWS=`cat $F | wc -l|sed 's/ //g'`
      #check_topic_count GDELT_EVENT02 ${F} $TARGET_ROWS
  else
    echo;echo;echo;echo "(I) The latest file ${DT}.export.CSV.zip is not yet available. Wait, then retry."
  fi
fi
}  # end of get_latest_file

wgetfile()
{
 FILE=$1
 RETRY=$2

 wget --quiet $FILE
 if [ -f `basename $FILE` ]
 then
  return -1
 else
  if [ "$RETRY" = "RETRY" ]
  then
    echo "(W) $FILE not yet available, sleep 30 and retry"
    sleep 30
    wget $FILE
    if [ -f `basename $FILE` ]
    then
     echo "(I) success. Continuing"
     return 0
    fi
  fi
fi
}

setupdir
get_latest_file
