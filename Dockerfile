FROM debian:stable-slim

ARG DEBIAN_FRONTEND=noninteractive

ENV WINEARCH=win64
ENV WINEDEBUG=-all
ENV WINEPREFIX=/home/steam/.wine

COPY ./sources.list /etc/apt/sources.list

RUN . /etc/os-release && sed -i "s|CODENAME|$VERSION_CODENAME|g" /etc/apt/sources.list

RUN dpkg --add-architecture i386

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
        cabextract \
        curl \
        wine \
        wine:i386 \
        winetricks \
        xvfb

RUN useradd --home-dir /home/steam --create-home steam

COPY init.sh /home/steam/init.sh
RUN chmod +x /home/steam/init.sh && \
    chown steam:steam /home/steam/init.sh

USER steam

RUN $HOME/init.sh

RUN curl -s http://media.steampowered.com/installer/steamcmd_linux.tar.gz | tar -v -C $HOME -zx

RUN mkdir -p $HOME/space_engineers && \
    $HOME/steamcmd.sh \
        +login anonymous \
        +force_install_dir $HOME/space_engineers \
        +app_update 298740 \
        +quit
