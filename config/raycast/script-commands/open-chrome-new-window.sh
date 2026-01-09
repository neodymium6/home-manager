#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Open Chrome (New Window)
# @raycast.mode silent
# @raycast.packageName Browser

osascript <<'APPLESCRIPT'
tell application "Google Chrome"
  activate
  make new window
end tell
APPLESCRIPT
