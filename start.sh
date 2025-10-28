#!/bin/bash
set -e

#Install/update Counter-Strike 1.6 Dedicated Server
if [ ! -f "/dedicated_server/hlds_run" ]; then
    echo "installing cs 1.6 server"

    chmod +x ./steamcmd.sh
    ./steamcmd.sh +login anonymous \
            +force_install_dir /dedicated_server \
            +app_set_config 90 mod cstrike \
            +app_update 90 -beta steam_legacy validate \
            +quit
else
    echo "cs 1.6 already installed! skipping.."
fi

if [ ! -f "/dedicated_server/rehlds_implemented" ]; then
    echo "installing rehlds and metamod"
    wget https://github.com/rehlds/ReHLDS/releases/download/3.14.0.857/rehlds-bin-3.14.0.857.zip
    unzip -o rehlds-bin-3.14.0.857.zip "bin/linux32/*"
    cp -R bin/linux32/* /dedicated_server
    rm -rf rehlds-bin-3.14.0.857.zip bin
    touch /dedicated_server/rehlds_implemented
    echo "rehlds and metamod installed"
else
    echo "rehlds is already installed"
fi

#Launch CS 1.6 server
cd /dedicated_server

chmod +x ./hlds_run
chmod +x ./hlds_linux

./hlds_run -game cstrike \
           +maxplayers 32 \
           +map de_dust2 \
           +port 27015 \
           +sv_lan 0 \
           +version \
           -console
