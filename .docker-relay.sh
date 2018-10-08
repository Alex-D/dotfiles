#!/bin/sh

if [ "$(id -u)" != "0"  ]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

rm -f /var/run/docker.sock
exec socat UNIX-LISTEN:/var/run/docker.sock,fork,group=docker,umask=007 EXEC:"npiperelay.exe -ep -s //./pipe/docker_engine",nofork
