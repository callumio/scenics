#!/usr/bin/env sh

grep '^pkgs/' | cut -d'/' -f2 | cut -d'.' -f1 | sort -u | jq -R '{"package": .}' | jq -sc '{"include": .}'
