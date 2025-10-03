#!/usr/bin/bash
if [ -z "$NTFY_TOKEN" ]; then
    echo "Error: NTFY_TOKEN environment variable not set."
    exit 1
fi

TOPIC="humlgs-gondor"
MESSAGE="$1"
TITLE="${2:-Server Notice}"
PRIORITY="${3:-3}"

if [ -z "$TOPIC" ] || [ -z "$MESSAGE" ]; then
    echo "Usage: NTFY_TOKEN=token $0 <topic> <message> [title] [priority]"
    exit 1
fi

curl -s \
  -H "Authorization: Bearer $NTFY_TOKEN" \
  -H "Title: $TITLE" \
  -H "Priority: $PRIORITY" \
  -d "$MESSAGE" \
  "https://ntfy.sh/$TOPIC"