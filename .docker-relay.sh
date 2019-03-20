#!/bin/sh

# See https://blogs.technet.microsoft.com/virtualization/2017/12/08/wsl-interoperability-with-docker/

if [ "$(id -u)" != "0"  ]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

rm -f /var/run/docker.sock
exec socat UNIX-LISTEN:/var/run/docker.sock,fork,group=docker,umask=007 EXEC:"npiperelay.exe -ep -s //./pipe/docker_engine",nofork
