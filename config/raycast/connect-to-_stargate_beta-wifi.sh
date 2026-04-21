#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title connect to _stargate_beta wifi
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.description connect to _stargate_beta wifi
# @raycast.author pakkerman
# @raycast.authorURL https://raycast.com/pakkerman

source ./.env
networksetup -setairportnetwork en0 _stargate_beta "$WIFI_PASSWORD" &
