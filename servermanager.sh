#!/bin/bash

# SteamCMD APPID for the-forest-dedicated-server
SAVEGAME_PATH="/theforest/saves"
CONFIG_PATH="/theforest/config"
CONFIGFILE_PATH="/theforest/config/config.cfg"

# Include defaults and common functions
. /defaults

function isServerRunning() {
    if ps axg | grep -F "TheForestDedicatedServer.exe" | grep -v -F 'grep' > /dev/null; then
        true
    else
        false
    fi
}

function isVirtualScreenRunning() {
    if ps axg | grep -F "Xvfb :1 -screen 0 1024x768x24" | grep -v -F 'grep' > /dev/null; then
        true
    else
        false
    fi
}

function setupWineInBashRc() {
    echo "Setting up Wine in bashrc"
    mkdir -p /winedata/WINE64
    if [ ! -d /winedata/WINE64/drive_c/windows ]; then
      cd /winedata
      echo "Setting up WineConfig and waiting 15 seconds"
      winecfg > /dev/null 2>&1
      sleep 15
    fi
    cat >> /etc/bash.bashrc <<EOF
export WINEPREFIX=/winedata/WINE64
export WINEARCH=win64
export DISPLAY=:1.0
EOF
}

function isWineinBashRcExistent() {
    grep "wine" /etc/bash.bashrc > /dev/null
    if [[ $? -ne 0 ]]; then
        echo "Checking if Wine is set in bashrc"
        setupWineInBashRc
    fi
}

function startVirtualScreenAndRebootWine() {
    # Start X Window Virtual Framebuffer
    export WINEPREFIX=/winedata/WINE64
    export WINEARCH=win64
    export DISPLAY=:1.0
    Xvfb :1 -screen 0 1024x768x24 &
    wineboot -r
}

function installServer() {
    # force a fresh install of all
    isWineinBashRcExistent
    steamcmdinstaller.sh
    mkdir -p "${SAVEGAME_PATH}" "${CONFIG_PATH}"
    cp /server.cfg.example "${CONFIGFILE_PATH}"
    sed -i -e "s/##SERVER_IP##/${SERVER_IP}/g" "${CONFIGFILE_PATH}"
    sed -i -e "s/##SERVER_STEAM_PORT##/${SERVER_STEAM_PORT}/g" "${CONFIGFILE_PATH}"
    sed -i -e "s/##SERVER_GAME_PORT##/${SERVER_GAME_PORT}/g" "${CONFIGFILE_PATH}"
    sed -i -e "s/##SERVER_QUERY_PORT##/${SERVER_QUERY_PORT}/g" "${CONFIGFILE_PATH}"
    sed -i -e "s/##SERVER_NAME##/${SERVER_NAME}/g" "${CONFIGFILE_PATH}"
    sed -i -e "s/##SERVER_PLAYERS##/${SERVER_PLAYERS}/g" "${CONFIGFILE_PATH}"
    sed -i -e "s/##ENABLE_VAC##/${ENABLE_VAC}/g" "${CONFIGFILE_PATH}"
    sed -i -e "s/##SERVER_PASSWORD##/${SERVER_PASSWORD}/g" "${CONFIGFILE_PATH}"
    sed -i -e "s/##SERVER_PASSWORD_ADMIN##/${SERVER_PASSWORD_ADMIN}/g" "${CONFIGFILE_PATH}"
    sed -i -e "s/##SERVER_STEAM_ACCOUNT##/${SERVER_STEAM_ACCOUNT}/g" "${CONFIGFILE_PATH}"
    sed -i -e "s/##SERVER_AUTOSAVE_INTERVAL##/${SERVER_AUTOSAVE_INTERVAL}/g" "${CONFIGFILE_PATH}"
    sed -i -e "s/##DIFFICULTY##/${DIFFICULTY}/g" "${CONFIGFILE_PATH}"
    sed -i -e "s/##INIT_TYPE##/${INIT_TYPE}/g" "${CONFIGFILE_PATH}"
    sed -i -e "s/##SLOT##/${SLOT}/g" "${CONFIGFILE_PATH}"
    sed -i -e "s/##SHOW_LOGS##/${SHOW_LOGS}/g" "${CONFIGFILE_PATH}"
    sed -i -e "s/##SERVER_CONTACT##/${SERVER_CONTACT}/g" "${CONFIGFILE_PATH}"
    sed -i -e "s/##VEGAN_MODE##/${VEGAN_MODE}/g" "${CONFIGFILE_PATH}"
    sed -i -e "s/##VEGETARIAN_MODE##/${VEGETARIAN_MODE}/g" "${CONFIGFILE_PATH}"
    sed -i -e "s/##RESET_HOLES_MODE##/${RESET_HOLES_MODE}/g" "${CONFIGFILE_PATH}"
    sed -i -e "s/##TREE_REGROW_MODE##/${TREE_REGROW_MODE}/g" "${CONFIGFILE_PATH}"
    sed -i -e "s/##ALLOW_BUILDING_DESTRUCTION##/${ALLOW_BUILDING_DESTRUCTION}/g" "${CONFIGFILE_PATH}"
    sed -i -e "s/##ALLOW_ENEMIES_CREATIVE_MODE##/${ALLOW_ENEMIES_CREATIVE_MODE}/g" "${CONFIGFILE_PATH}"
    sed -i -e "s/##ALLOW_CHEATS##/${ALLOW_CHEATS}/g" "${CONFIGFILE_PATH}"
    sed -i -e "s/##REALISTIC_PLAYER_DAMAGE##/${REALISTIC_PLAYER_DAMAGE}/g" "${CONFIGFILE_PATH}"
    bash /steamcmd/steamcmd.sh +runscript /steamcmdinstall.txt
}


function startServer() {
    if ! isVirtualScreenRunning; then
        startVirtualScreenAndRebootWine
    fi
    rm /tmp/.X1-lock 2> /dev/null
    cd /theforest
    wine64 /theforest/TheForestDedicatedServer.exe -batchmode -nographics -nosteamclient -savefolderpath "${SAVEGAME_PATH}" -configfilepath "${CONFIGFILE_PATH}"
}

function startMain() {
    # Check if server is installed, if not try again
    if [ ! -f "/theforest/TheForestDedicatedServer.exe" ]; then
        installServer
    fi
    startServer
}

startMain
