#!/bin/bash -ex
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source "$DIR/secrets"

if [[ -z $GODADDY_API_KEY || -z $GODADDY_API_SECRET || -z $GODADDY_URL ]] ; then 
	echo "godaddy api key/secret/url must be set in $DIR/secrets"
	exit 12
fi

export SNAP=/snap/nextcloud/current
export PATH="$SNAP/usr/sbin:$SNAP/usr/bin:$SNAP/sbin:$SNAP/bin:$PATH"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$SNAP/lib:$SNAP/usr/lib:$SNAP/lib/x86_64-linux-gnu:$SNAP/usr/lib/x86_64-linux-gnu"
export LD_LIBRARY_PATH="$SNAP/lib/x86_64-linux-gnu:$SNAP/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH"
export LD_LIBRARY_PATH=$SNAP_LIBRARY_PATH:$LD_LIBRARY_PATH
export PYTHONPATH="$DIR/pysite:$SNAP/usr/lib/python2.7:$SNAP/usr/lib/python2.7/plat-x86_64-linux-gnu:$SNAP/usr/lib/python2.7/lib-tk:$SNAP/usr/lib/python2.7/lib-old:$SNAP/usr/lib/python2.7/lib-dynload:$SNAP/usr/local/lib/python2.7/dist-packages:$SNAP/usr/lib/python2.7/dist-packages"

cd "/var/snap/nextcloud"

source "$SNAP/utilities/https-utilities"


if ! run_certbot certonly \
	--authenticator=manual \
	--preferred-challenges=dns \
	--manual-auth-hook=/var/snap/nextcloud/common/dns-challenge/auth-hook \
	--manual-cleanup-hook=/var/snap/nextcloud/common/dns-challenge/cleanup-hook \
	--manual-public-ip-logging-ok \
	--rsa-key-size 4096 \
	--agree-tos \
	--force-renewal ; then
	printf "error running certbot:\n\n" >&2
	echo "$output" >&2
	exit 1
fi
