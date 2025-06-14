#!/usr/bin/env bash

if [ "$#" -ne 1 ]; then
	echo "Usage: $0 <plugin_url>"
	exit 1
fi

PLUGIN_URL=$1
PLUGIN_NAME=$(basename "$PLUGIN_URL" .git)
PLUGIN_DIR="common/.zsh_plugins"

git submodule add "$PLUGIN_URL" "$PLUGIN_DIR/$PLUGIN_NAME" || {
	echo "Failed to add plugin $PLUGIN_NAME"
	exit 1
}
