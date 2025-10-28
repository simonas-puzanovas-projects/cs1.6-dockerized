FROM debian:bookworm

#steamcmd
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && \
    apt install -y unzip wget curl && \
    dpkg --add-architecture i386 && \
    apt install -y software-properties-common lib32gcc-s1 lib32stdc++6 libcurl4 && \
    apt update && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /steam
WORKDIR /steam

#fixing steam_client.so issue
RUN curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -
RUN mkdir -p /root/.steam/sdk32
RUN ln -s /steam/linux32/steamclient.so /root/.steam/sdk32/steamclient.so

#running the setup and start script
COPY start.sh start.sh
RUN chmod +x start.sh
CMD ["./start.sh"]
