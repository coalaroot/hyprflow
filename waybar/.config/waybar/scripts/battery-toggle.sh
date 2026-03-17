#!/bin/bash

PROFILE=$(powerprofilesctl get 2>/dev/null)

case "$PROFILE" in
  "performance") powerprofilesctl set power-saver ;;
  "power-saver") powerprofilesctl set balanced ;;
  "balanced")    powerprofilesctl set performance ;;
esac
