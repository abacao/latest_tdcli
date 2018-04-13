#!/usr/bin/env bash

# Downloads the latest release from td-cli https://github.com/Talkdesk/td-cli
#
# Requires: oauth token, https://help.github.com/articles/creating-an-access-token-for-command-line-use/
# Requires: jq package to parse json

OAUTH_TOKEN="$BUNDLE_GITHUB__COM"                                     # Your oauth token
OWNER="Talkdesk"                                                      # Repo owner (org id)
REPO="td-cli"                                                         # Repo name
API_URL="https://$OAUTH_TOKEN:@api.github.com/repos/$OWNER/$REPO"     # Building the API URL

# Determines if you are using MAC or LINUX and choose the proper download file.
os_type=`uname`
if  [ "$os_type" = "Linux" ]; then
  FILE_NAME="td-linux-amd64.tar.gz";                                   # Filename for Linux
  ASSET_ID=$(curl $API_URL/releases/latest | jq -r '.assets[1].id');
elif [ "$os_type" = "Darwin" ]; then
  FILE_NAME="td-darwin-amd64.tar.gz"                                   # Filename for Linux
  ASSET_ID=$(curl $API_URL/releases/latest | jq -r '.assets[0].id');
else
    echo "${os_type} is not supported" >&2
    exit 1
fi
echo "Asset ID: $ASSET_I";

# curl does not allow overwriting file from -O, nuke
rm -f $FILE_NAME
# getting release
curl -O -J -L -H "Accept: application/octet-stream" "$API_URL/releases/assets/$ASSET_ID"
tar -xvf $FILE_NAME
rm -f $FILE_NAME
