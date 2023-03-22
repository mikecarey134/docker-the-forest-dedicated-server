## Docker - The Forest Dedicated Server
This includes a The Forest Dedicated Server based on Docker with Wine and an example config.

## What you need to run this
* Basic understanding of Linux and Docker

## Getting started
WARNING: If you do not do Step 1 and 2 your server can/will not save!
1. Create a new game server account over at https://steamcommunity.com/dev/managegameservers (Use AppID: `242760`)
2. Insert the Login Token into file SteamToken file without spaces before or after
4. Start the container with the following examples:

Bash:
```
run ./run-docker-server.sh after building with ./build-docker-server.sh or run ./build-and-run-docker-server.sh
```
Docker-Compose:
```yaml
version: "3.7"
services:
  the-forest-dedicated-server:
    container_name: the-forest-dedicated-server
    image: theforestdedicated:latest
    restart: unless-stopped
    environment:
      SERVER_STEAM_ACCOUNT_TOKEN: SERVER_STEAM_ACCOUNT_TOKEN
    ports:
      - 8766:8766/tcp
      - 8766:8766/udp
      - 27015:27015/tcp
      - 27015:27015/udp
      - 27016:27016/tcp
      - 27016:27016/udp
    volumes:
      - /steamcmd:/steamcmd
      - /game:/theforest
      - /winedata:/winedata
```

## Environment variables

| Env                         | default              | description |
|---------------------------- |----------------------|-------------|
| TIME_ZONE                   | Etc/UTC              | Timezone                  |
| STEAM_APP_ID                | 556450               | steamappid                |
| SERVER_IP                   | 0.0.0.0              | Server IP address         |
| SERVER_STEAM_PORT           | 8766                 | Steam Communication Port  |
| SERVER_GAME_PORT            | 27015                | Game Communication Port   |
| SERVER_QUERY_PORT           | 27016                | Query Communication Port  |
| SERVER_NAME                 | the-forest-server-01 | Server display name       |
| SERVER_PLAYERS              | 8                    | Maximum number of players |
| ENABLE_VAC                  | on                   | Enable VAC                |
| SERVER_PASSWORD             |                      | Server password. Blank means no password. It is recommended to have a password to prevent griefers.                        |
| SERVER_PASSWORD_ADMIN       |                      | Server administration password. Blank means no password.                                                                   |
| SERVER_STEAM_ACCOUNT        |                      | Don't leave this blank or use your actual Steam account name.The Forest App ID number is 242760. DO NOT SHARE THIS CODE!   |
| SERVER_AUTOSAVE_INTERVAL    | 30                   | Time between server auto saves in minutes - The minumum time is 15 minutes                                                 |
| DIFFICULTY                  | Normal               | Game difficulty mode. Must be set to Peaceful / Normal / Hard / HardSurvival                                               |
| INIT_TYPE                   | Continue             | Must be set to New or Continue. If left on New, the game won't save and you will have to restart each time.                |
| SLOT                        | 1                    | Slot to save the game. Must be set to either slot 1 / slot 2 / slot 3 / slot 4 / slot 5.                                   |
| SHOW_LOGS                   | off                  | Show event log. Must be set off or on. It is highly recommended to leave this on, this will show if your server is working or not and what issues you may be having, if any. Options are showLogs on or showLogs off. |
| SERVER_CONTACT              | email@gmail.com      | Contact email for server admin. Not required.                                    |
| VEGAN_MODE                  | off                  | No enemies if switched off. Options are veganMode on or veganMode off.           |
| VEGETARIAN_MODE             | off                  | No enemies during day time. Options are vegetarianMode on or vegetarianMode off. |
| RESET_HOLES_MODE            | off                  | Reset all structure holes when loading a save. These are holes caused by the hole cutter. This has the same effect as the woodpaste command. Options are resetHolesMode on or resetHolesMode off |
| TREE_REGROW_MODE            | off                  | Regrow 10% of cut down trees when sleeping. Options are treeRegrowMode on or treeRegrowMode off           |
| ALLOW_BUILDING_DESTRUCTION  | on                   | Allow building destruction. Options are allowBuildingDestruction on or allowBuildingDestruction off       |
| ALLOW_ENEMIES_CREATIVE_MODE | off                  | Allow enemies in creative games. Options are allowEnemiesCreativeMode on or allowEnemiesCreativeMode off. |
| ALLOW_CHEAT                 | off                  | Allow clients to use the built in debug console. This only disables console commands, it has no effect on mods such as the Ultimate Cheat Menu. People can still grief your game. Options are allowCheats on or allowCheats off. |
| REALISTIC_PLAYER_DAMAGE     | off                  | Realistic Player Damage (On/Off), this allows the game to be more PvP based. Damage to other players will be increased dramatically, depending on the weapon. |

## Planned features in the future
Backups for slot saves

## Software used
* Debian Slim Stable
* Xvfb
* Winbind
* Wine
* SteamCMD
* TheForest Dedicated Server
