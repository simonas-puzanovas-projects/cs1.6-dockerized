#!/bin/bash
#set -e

#compile scripts
cd /dedicated_server/cstrike/addons/amxmodx/scripting
cp /custom_scripting/* .
chmod +x ./compile.sh
./compile.sh 2>&1 | grep --color=always -iE "error|warning" || true
mv compiled/* ../plugins

cd /dedicated_server
./hlds_run -game cstrike \
           +maxplayers 32 \
           +map de_dust2 \
           +port 27015 \
           +sv_lan 0 \
           +version \
           -console
