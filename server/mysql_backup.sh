#!/bin/sh

set -e

# Params
#   DB_USER: Username
#   DB_PWD: Password
#   1st argument: Database name

DB_NAME=$1

CONFIG_PATH="$HOME/.config/backup/mysql"
. "$CONFIG_PATH"

TMP_DIR="/tmp"
DUMP_PATH="$TMP_DIR/$DB_NAME.sql.gz"
DROPBOX_UPLOADER_CONFIG_PATH="$HOME/.dropbox_uploader"

MYSQL_PWD="$DB_PWD" mysqldump -u"$DB_USER" "$DB_NAME" | gzip > "$DUMP_PATH"

dropbox_uploader -f "$DROPBOX_UPLOADER_CONFIG_PATH" upload "$DUMP_PATH" /

rm -f "$DUMP_PATH"
