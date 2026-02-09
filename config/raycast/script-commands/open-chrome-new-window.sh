#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Open Chrome (New Window)
# @raycast.mode silent
# @raycast.packageName Browser

osascript <<'APPLESCRIPT' >/dev/null
set appName to "Google Chrome"

if application appName is not running then
  tell application appName
    activate
    delay 0.1
    make new window
  end tell
  return
end if

set hasWindowHere to false
tell application "System Events"
  try
    set hasWindowHere to ((count (windows of process appName where value of attribute "AXMinimized" is false)) > 0)
  end try
end tell

if hasWindowHere then
  tell application appName
    activate
    make new window
  end tell
else
  tell application appName to make new window

  tell application "System Events"
    repeat until (count (windows of process appName where value of attribute "AXMinimized" is false)) > 0
      delay 0.05
    end repeat
  end tell

  tell application appName to activate
end if
APPLESCRIPT
