#!/bin/bash

APP_DIR="/var/_localApp"
DATA_DIR="/var/_localAppData"

CRON_PATH=$DATA_DIR/cron
TMP_PATH=$DATA_DIR/tmp
LOG_PATH=$DATA_DIR/log
SCHEDULE_PATH=${DATA_DIR}/scheduledTasks
OUTPUT_PATH=$DATA_DIR/output

mkdir -p $SCHEDULE_PATH
mkdir -p $CRON_PATH
mkdir -p $TMP_PATH
mkdir -p $LOG_PATH
mkdir -p $OUTPUT_PATH

markfile=$DATA_DIR/mark.data

# --- clean longer time task -----
for file in $(find $markfile -not -newermt '-120 seconds' 2>&1) ;do
  if [ -f "$markfile" ]; then
    vfn=$(<$markfile)
    cmda="rm -fr $vfn && pkill -f $vfn > /dev/null && rm -fr $markfile >/dev/null 2>&1"
    eval "$cmda"
  fi
done

for f in "$CRON_PATH"/*; do

  if [ -f "$markfile" ]; then
    break;
  fi

  if [ -f "$f" ]; then

    execfn=$TMP_PATH/SH_$(basename $f)
    echo $execfn > $markfile
    echo "Pass through  $f \n\t From $(date +"%m-%d %H:%M:%S")"  >> $LOG_PATH/mainService.sh.log
    mv -f $f $execfn || true
    cd $APP_DIR
    # cat $execfn | sed 's/^/\t>>\t/' >> $LOG_PATH/mainService.sh.log
    sh $execfn | sed 's/^/\t>>\t/' >> $LOG_PATH/mainService.sh.log
    rm -fr $execfn || true
    rm -fr $markfile || true
    echo "\t done $f at $(date +"%m/%d/%Y %H:%M:%S")" >> $LOG_PATH/mainService.sh.log
  else
    exit 1
  fi
done
