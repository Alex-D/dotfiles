#!/bin/sh

set -e

# Params
#   @: folder path list to backup

TMP_DIR="/tmp"
BACKUP_FILE="$TMP_DIR/backup.tar"
DROPBOX_UPLOADER_CONFIG_PATH="$HOME/.dropbox_uploader"

tar \
  --exclude-vcs \
  --exclude-backups \
  --exclude "*app/cache*" \
  --exclude "*var/cache*" \
  --exclude "*vendor*" \
  -czf \
  "$BACKUP_FILE" \
  "$@"

dropbox_uploader -f "$DROPBOX_UPLOADER_CONFIG_PATH" upload "$BACKUP_FILE.gz" /

rm -f "$BACKUP_FILE.gz"
