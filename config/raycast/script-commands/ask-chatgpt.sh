#!/usr/bin/env bash

# @raycast.schemaVersion 1
# @raycast.title Ask ChatGPT
# @raycast.mode silent
# @raycast.packageName ChatGPT
# @raycast.icon 🤖
# @raycast.argument1 { "type": "text", "placeholder": "Prompt" }

set -euo pipefail

PROMPT="$*"
APP="Google Chrome"
URL="https://chatgpt.com/"

if [[ -z "${PROMPT}" ]]; then
  open -a "$APP" "$URL"
  exit 0
fi

printf %s "$PROMPT" | pbcopy

open -a "$APP" "$URL"

/usr/bin/osascript \
  -e "tell application \"$APP\" to activate" \
  -e "delay 1.2" \
  -e "tell application \"System Events\" to keystroke \"v\" using {command down}" \
  -e "tell application \"System Events\" to key code 36"
