#!/bin/bash
set -e

cd /dedicated_server
./hlds_run -game cstrike \
           +maxplayers 32 \
           +map de_dust2 \
           +port 27015 \
           +sv_lan 0 \
           +version \
           -console
