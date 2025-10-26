#!/bin/bash
ls

#Install/update Counter-Strike 1.6 Dedicated Server
echo "installing cs 1.6 server"
if [ ! -d "/steam/cs16" ]; then
    chmod +x ./steamcmd.sh
    ./steamcmd.sh +login anonymous \
            +force_install_dir /steam/cs16 \
            +app_set_config 90 mod cstrike \
            +app_update 90 -beta steam_legacy validate \
            +quit
else
    echo "cs 1.6 already installed! skipping.."
fi


echo "installing rehlds and metamod"
wget https://github.com/rehlds/ReHLDS/releases/download/3.14.0.857/rehlds-bin-3.14.0.857.zip
unzip -o rehlds-bin-3.14.0.857.zip "bin/linux32/*"
cp -rf bin/linux32/* /steam/cs16/
rm -rf rehlds-bin-3.14.0.857.zip bin
echo "rehlds and metamod installed"

#Launch CS 1.6 server
cd /steam/cs16
chmod +x ./hlds_run
chmod +x ./hlds_linux

./hlds_run -game cstrike \
           +maxplayers 32 \
           +map de_dust2 \
           +port 27015 \
           +sv_lan 0 \
           +version \
           -console
