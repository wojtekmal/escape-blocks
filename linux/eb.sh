#!/bin/sh
echo -ne '\033c\033]0;Escape blocks\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/eb.x86_64" "$@"
