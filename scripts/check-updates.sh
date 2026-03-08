#!/bin/bash

# Check for system updates
UPDATES=$(apt list --upgradable 2>/dev/null | grep -v "Listing" | wc -l)

# Check for npm global updates
NPM_UPDATES=$(npm outdated -g --depth=0 2>/dev/null | grep -v "Package" | wc -l)

# Check OpenClaw version
CURRENT=$(openclaw --version 2>/dev/null)
LATEST=$(npm view openclaw version 2>/dev/null)

OPENCLAW_UPDATE=""
if [ "$CURRENT" != "$LATEST" ]; then
    OPENCLAW_UPDATE="OpenClaw: $CURRENT -> $LATEST"
fi

# Send notification if there are updates
if [ "$UPDATES" -gt 0 ] || [ "$NPM_UPDATES" -gt 0 ] || [ -n "$OPENCLAW_UPDATE" ]; then
    MESSAGE="📦 Updates available:"
    [ "$UPDATES" -gt 0 ] && MESSAGE="$MESSAGE\n- $UPDATES system packages"
    [ "$NPM_UPDATES" -gt 0 ] && MESSAGE="$MESSAGE\n- $NPM_UPDATES npm packages"
    [ -n "$OPENCLAW_UPDATE" ] && MESSAGE="$MESSAGE\n- $OPENCLAW_UPDATE"
    
    # Send via OpenClaw message if possible, otherwise echo
    echo -e "$MESSAGE"
fi
