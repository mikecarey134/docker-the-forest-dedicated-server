FROM debian:bullseye-slim

LABEL maintainer="Mike Carey"

ARG SERVER_STEAM_ACCOUNT_TOKENIN

ENV DEBIAN_FRONTEND=noninteractive \
    WINEARCH=win64 \
    WINEPREFIX=/winedata/WINE64 \
    DISPLAY=:1.0 \
    PGID=0 \
    PUID=0 \
    SERVER_STEAM_ACCOUNT_TOKEN=$SERVER_STEAM_ACCOUNT_TOKENIN \
    TIME_ZONE=Etc/UTC

VOLUME ["/theforest", "/steamcmd", "/winedata"]

EXPOSE 8766/tcp 8766/udp 27015/tcp 27015/udp 27016/tcp 27016/udp

RUN echo "SERVER_STEAM_ACCOUNT_TOKEN VALUE: $SERVER_STEAM_ACCOUNT_TOKEN"

RUN sed -i \
        -e 's|deb.debian.org/debian-security|snapshot.debian.org/archive/debian-security/20260903T220410Z|g' \
        -e 's|deb.debian.org/debian|archive.debian.org/debian|g' \
        /etc/apt/sources.list \
    && sed -i \
        -e 's|deb.debian.org/debian-security|snapshot.debian.org/archive/debian-security/20260903T220410Z|g' \
        -e 's|deb.debian.org/debian|archive.debian.org/debian|g' \
        /etc/apt/sources.list.d/*.list 2>/dev/null || true \
    && echo 'Acquire::Check-Valid-Until "false";' \
        > /etc/apt/apt.conf.d/99archive \
    && dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get dist-upgrade -y \
    && apt-get -y --no-install-recommends --no-install-suggests install \
        apt-transport-https \
        gnupg2 \
        lib32gcc-s1 \
        nano \
        procps \
        software-properties-common \
        sudo \
        wget \
        winbind \
        xvfb \
    && wget https://dl.winehq.org/wine-builds/winehq.key \
    && apt-key add winehq.key \
    && rm winehq.key \
    && echo "deb https://dl.winehq.org/wine-builds/debian/ bullseye main" \
        >> /etc/apt/sources.list.d/winehq.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends winehq-stable \
    && apt-get remove -y --purge \
        apt-transport-https \
        gnupg2 \
        software-properties-common \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY servermanager.sh steamcmdinstaller.sh /usr/bin/
COPY defaults steamcmdinstall.txt server.cfg.example ./

RUN ln -snf /usr/share/zoneinfo/$TIME_ZONE /etc/localtime \
    && echo "$TIME_ZONE" > /etc/timezone \
    && chmod +x /usr/bin/servermanager.sh /usr/bin/steamcmdinstaller.sh

CMD ["servermanager.sh"]
