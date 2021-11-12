#!/usr/bin/bash

# TODO: find a cleaner way to compose JSON
contents="$(jq -n \
   --arg k1 'appName' \
   --arg v1 "$1" \
   --arg k2 'appId' \
   --arg v2 "$2" \
   --arg k3 'flavourName' \
   --arg v3 "$3" \
   --arg k4 'prefix' \
   --arg v4 "$4" \
   --arg k5 'appLabel' \
   --arg v5 "$5" \
   --arg k6 'imageUrl' \
   --arg v6 "$6" \
   --arg k7 'introsliders' \
   --arg v7 "$7" \
   '. | .[$k1]=$v1 | .[$k2]=$v2 | .[$k3]=$v3 | .[$k4]=$v4 | .[$k5]=$v5| .[$k6]=$v6| .[$k7]=$v7' \
   <<<'{}'
)"
rm app/flavours/flavourfiles.json
rm marketPlace/flavours/flavourfiles.json

echo "$contents"
echo "$contents"| jq -n '.flavours |= [inputs]'> app/flavours/flavourfiles.json
echo "$contents"| jq -n '.flavours |= [inputs]'> marketPlace/flavours/flavourfiles.json

# Asset generation
# Prerequistes for the below is a gm binary.
# Run `brew install graphicsmagick` on Mac
# Run `sudo apt-get install graphicsmagick` on Linux
APP_DIR=app/src/$3
rm -rf $APP_DIR/res
mkdir -p $APP_DIR/res
mkdir -p $APP_DIR/res/mipmap-xxxhdpi
mkdir -p $APP_DIR/res/mipmap-xxhdpi
mkdir -p $APP_DIR/res/mipmap-xhdpi
mkdir -p $APP_DIR/res/mipmap-hdpi
mkdir -p $APP_DIR/res/mipmap-mdpi
curl -sSf -u "admin:Winuall@123" "$6" -o $APP_DIR/ic_launcher.png
convert $APP_DIR/ic_launcher.png -resize 144x144 $APP_DIR/res/mipmap-xxhdpi/ic_launcher.png
convert $APP_DIR/ic_launcher.png -resize 96x96 $APP_DIR/res/mipmap-xhdpi/ic_launcher.png
convert $APP_DIR/ic_launcher.png -resize 72x72 $APP_DIR/res/mipmap-hdpi/ic_launcher.png
convert $APP_DIR/ic_launcher.png -resize 48x48 $APP_DIR/res/mipmap-mdpi/ic_launcher.png
convert $APP_DIR/ic_launcher.png -resize 192x192 $APP_DIR/res/mipmap-xxxhdpi/ic_launcher.png

# Format google-services.json
jq --arg var "$2" '.client[0].client_info.android_client_info.package_name = $var' app/google-services.json|sponge app/google-services.json