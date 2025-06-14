#!/usr/bin/env bash

if [ "$#" -ne 1 ]; then
	echo "Usage: $0 <plugin_name>"
	exit 1
fi

PLUGIN_NAME=$1
PLUGIN_DIR="common/.zsh_plugins"

git rm --cached "$PLUGIN_DIR/$PLUGIN_NAME" -f || {
	echo "Failed to remove plugin $PLUGIN_NAME"
	exit 1
}
