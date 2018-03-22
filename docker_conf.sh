#!/bin/bash

set -e

pushd /etc/docker

echo '========================================'
echo '| Before'
echo '========================================'

cat 'daemon.json' | tee 'daemon.json.bak' | jq -e '.'

echo '========================================'
echo '| After'
echo '========================================'

cat 'daemon.json.bak'                                                                                       \
| jq -e '. |= . + {"storage-driver":"devicemapper"}'                                                        \
| jq -e '. |= . + {"storage-opts":[]}'                                                                      \
| jq -e '."storage-opts"[."storage-opts" | length] |= . + "dm.thinpooldev=/dev/mapper/Mocha-docker--pool"'  \
| jq -e '."storage-opts"[."storage-opts" | length] |= . + "dm.use_deferred_removal=true"'                   \
| jq -e '."storage-opts"[."storage-opts" | length] |= . + "dm.use_deferred_deletion=true"'                  \
| tee 'daemon.json' | jq -e '.'                                                                             \
|| ( set -e
    cat 'daemon.json.bak' > 'daemon.json'
    false
)