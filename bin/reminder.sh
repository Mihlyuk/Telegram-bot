#!/bin/bash

CHATID="279495348"
KEY="282969345:AAEkW0070hAfVNlqKasIPvNYF076ANBSoMs"
TIME="10"
URL="https://api.telegram.org/bot$KEY/sendMessage"
TEXT="Hello world"

curl -s --max-time $TIME -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT" $URL >/dev/null