#!/usr/bin/env bash

{ while ! ping -c1 1.1.1.1 &>/dev/null; do sleep 1; done
  jellyfin-mpv-shim
} &
