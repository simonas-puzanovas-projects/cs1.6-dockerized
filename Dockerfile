FROM debian:bookworm

#steamcmd stuff
ENV DEBIAN_FRONTEND=noninteractive

#buildtime variables
ENV REHLDS_VERSION=3.14.0.857
ENV METAMOD_VERSION=1.3.0.149
ENV AMXMODX_BASE_VERSION=1.8.2

#dependencies
RUN apt update && \
    apt install -y unzip wget curl && \
    dpkg --add-architecture i386 && \
    apt install -y software-properties-common lib32gcc-s1 lib32stdc++6 libcurl4 && \
    apt update && \
    rm -rf /var/lib/apt/lists/*

#steamcmd installation
RUN mkdir /steam
WORKDIR /steam
RUN curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -

#installing cs 1.6
RUN chmod +x ./steamcmd.sh
RUN ./steamcmd.sh \
            +force_install_dir /dedicated_server \
            +login anonymous \
            +app_set_config 90 mod cstrike \
            +app_update 90 -beta steam_legacy validate \
            +quit

#ReHLDS
RUN wget https://github.com/rehlds/ReHLDS/releases/download/${REHLDS_VERSION}/rehlds-bin-${REHLDS_VERSION}.zip
RUN unzip -o rehlds-bin-${REHLDS_VERSION}.zip "bin/linux32/*"
RUN cp -R bin/linux32/* /dedicated_server
RUN rm -rf rehlds-bin-${REHLDS_VERSION}.zip bin

#Metamod
RUN mkdir /dedicated_server/cstrike/addons
RUN wget https://github.com/rehlds/Metamod-R/releases/download/${METAMOD_VERSION}/metamod-bin-${METAMOD_VERSION}.zip
RUN unzip -o metamod-bin-${METAMOD_VERSION}.zip "addons/*"
RUN cp -R addons/* /dedicated_server/cstrike/addons
RUN rm -rf metamod-bin-${METAMOD_VERSION}.zip addons
COPY liblist.gam /dedicated_server/cstrike

#Amxmodx
RUN wget https://www.amxmodx.org/release/amxmodx-${AMXMODX_BASE_VERSION}-base-linux.tar.gz
RUN tar -xzf amxmodx-${AMXMODX_BASE_VERSION}-base-linux.tar.gz --wildcards "addons/*"
RUN cp -R addons/* /dedicated_server/cstrike/addons
RUN rm -rf amxmodx-${AMXMODX_BASE_VERSION}-base-linux.tar.gz addons
RUN touch /dedicated_server/cstrike/addons/metamod/plugins.ini
RUN echo "linux addons/amxmodx/dlls/amxmodx_mm_i386.so" >> /dedicated_server/cstrike/addons/metamod/plugins.ini

#fixing steam_client.so issue
RUN mkdir -p /root/.steam/sdk32
RUN ln -s /steam/linux32/steamclient.so /root/.steam/sdk32/steamclient.so

#pasting configs
COPY ./amxmodx/configs /dedicated_server/cstrike/addons/amxmodx/configs

#running the setup and start script
COPY start.sh start.sh

RUN chmod +x start.sh
RUN chmod +x /dedicated_server/hlds_run
RUN chmod +x /dedicated_server/hlds_linux

#CMD ["./start.sh"]
