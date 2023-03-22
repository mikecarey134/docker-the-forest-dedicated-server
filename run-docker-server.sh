#find TheForestDedicatedServer.exe if it exists and trigger a wine config to keep docker image running after a shutdown
FE="$(pwd)/theforest/game/TheForestDedicatedServer.exe"

if [[ -f $FE ]] 
then 
#remove TheForestDedicatedServer.exe if we find it
  echo "The file $FE exists." 
  rm $FE
else 
#otherwise ignore and redownload if needed
  echo "The file $FE cannot be found. Starting up normally" 
fi

#Map Steam Token
SK=$(cat SteamToken)
ENV="'SERVER_STEAM_ACCOUNT_TOKEN=${SK}'"

#Run Docker image and map directories and ports
docker run --rm -i -t -e $ENV -p 8766:8766/tcp -p 8766:8766/udp -p 27015:27015/tcp -p 27015:27015/udp -p 27016:27016/tcp -p 27016:27016/udp -v $(pwd)/theforest/steamcmd:/steamcmd -v $(pwd)/theforest/game:/theforest --name the-forest-dedicated-server theforestdedicated:latest