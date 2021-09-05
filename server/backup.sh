#!/bin/sh

set -e

# Params
#   @: folder path list to backup

TMP_DIR="/tmp"
BACKUP_FILE="$TMP_DIR/data.tar"
DROPBOX_UPLOADER_CONFIG_PATH="$HOME/.dropbox_uploader"

tar cf "$BACKUP_FILE" "$@"
gzip "$BACKUP_FILE"

dropbox_uploader -f "$DROPBOX_UPLOADER_CONFIG_PATH" upload "$BACKUP_FILE.gz" /

rm -f "$BACKUP_FILE.gz"
