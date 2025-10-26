#!/bin/bash
ls

#Install/update Counter-Strike 1.6 Dedicated Server
echo "installing cs 1.6 server"
chmod +x ./steamcmd.sh
./steamcmd.sh +login anonymous \
         +force_install_dir /cs16 \
         +app_set_config 90 mod cstrike \
         +app_update 90 -beta steam_legacy validate \
         +quit

cd /cs16
echo "installing rehlds and metamod"
wget https://github.com/rehlds/ReHLDS/releases/download/3.14.0.857/rehlds-bin-3.14.0.857.zip
unzip -o rehlds-bin-3.14.0.857.zip 
cp -rf bin/linux32/* .
rm -rf bin rehlds-bin-3.14.0.857.zip
echo "rehlds and metamod installed"

#Launch CS 1.6 server
./hlds_run -game cstrike \
           +maxplayers 32 \
           +map de_dust2 \
           +port 27015 \
           +sv_lan 0 \
           -console

echo "server launched"