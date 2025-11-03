#!/bin/bash
set -e

cd /dedicated_server
cat cstrike/addons/metamod/plugins.ini

./hlds_run -game cstrike \
           +maxplayers 32 \
           +map de_dust2 \
           +port 27015 \
           +sv_lan 0 \
           +version \
           -console
