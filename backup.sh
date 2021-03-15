#!/bin/bash

TMP_DIR="/tmp/"
DATE=$(date +"%Y-%m-%d_%Hh%M")
BKP_FILE="$TMP_DIR/data.tar"
BKP_DIRS="/home/user /var/www /etc"
DROPBOX_UPLOADER_CONFIG_PATH="/home/ademode/.dropbox_uploader"

tar cf "$BKP_FILE" $BKP_DIRS
gzip "$BKP_FILE"

dropbox_uploader -f $DROPBOX_UPLOADER_CONFIG_PATH upload "$BKP_FILE.gz" /

rm -fr "$BKP_FILE.gz"
