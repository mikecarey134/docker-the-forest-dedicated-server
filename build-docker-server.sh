#grab configured steam token
ST=$(cat SteamToken)
#pass into build as argument
docker build --build-arg SERVER_STEAM_ACCOUNT_TOKENIN=$ST -t theforestdedicated:latest .