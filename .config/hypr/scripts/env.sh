#!/usr/bin/env bash

ENV_FILE="$HOME/.config/hypr/conf/envs.conf"
SOURCE_ENV="$HOME/.config/.env"

rm -f "$ENV_FILE"
sed '/^\s*#/d;/^\s*$/d' "$SOURCE_ENV" | while IFS='=' read -r key val; do
  echo "env = $key,$val" >> "$ENV_FILE"
done

bat "$ENV_FILE"
