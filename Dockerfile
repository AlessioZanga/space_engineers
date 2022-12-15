# Load a Debian Stable Slim image.
FROM debian:stable-slim
# Set DEBIAN_FRONTEND for apt-get at build time.
ARG DEBIAN_FRONTEND=noninteractive
# Set Wine environmental variables.
ENV WINEARCH=win64
ENV WINEDEBUG=-all
ENV WINEPREFIX=/home/steam/.wine
# Configure apt-get sources.
COPY ./sources.list /etc/apt/sources.list
RUN . /etc/os-release && sed -i "s|CODENAME|$VERSION_CODENAME|g" /etc/apt/sources.list
# Enable 32-bit support.
RUN dpkg --add-architecture i386
# Install Wine.
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
        cabextract \
        curl \
        wine \
        wine:i386 \
        winetricks \
        xvfb
# Configure a non-root Steam user.
RUN useradd --home-dir /home/steam --create-home steam
# Prepare initialization script.
COPY init.sh /home/steam/init.sh
RUN chmod +x /home/steam/init.sh && \
    chown steam:steam /home/steam/init.sh
# Switch to non-root Steam user.
USER steam
# Configure Wine prefix.
RUN $HOME/init.sh
# Install SteamCMD - Steam command line interface.
RUN curl -s http://media.steampowered.com/installer/steamcmd_linux.tar.gz | tar -v -C $HOME -zx
# Install Space Engineers server from Steam.
RUN mkdir -p $HOME/space_engineers && \
    $HOME/steamcmd.sh \
        +login anonymous \
        +force_install_dir $HOME/space_engineers \
        +app_update 298740 \
        +quit

# Set Space Engineers server execution path.
CMD cd $HOME/space_engineers/DedicatedServer64/ && \
    # Run Space Engineers server with Wine.
    wine SpaceEngineersDedicated.exe \
    # Set data and configuration path.
    -path "Z:\\home\\steam\\data" \
    # Disable window system.
    -noconsole
