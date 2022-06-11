#!/usr/bin/env bash
set -e
set -o errexit

source ./retry.bash

here="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)"

function waitForDevice() {
  echo "Waiting for device"
  declare i
  i=0
  while true; do
    if [ "$(adb shell getprop sys.boot_completed | tr -d '\r')" = "1" ]; then # Based on https://stackoverflow.com/a/38896494
      echo "Device ready!"
      break
    fi
    i=$((i + 1))
    if [ "$i" -eq 300 ]; then
      echo "No signal from adb device after 5 minutes"
      exit 1
    fi
    sleep 1
  done
}

function waitForDeviceOff() {
  echo "Waiting for device off"
  declare i
  i=0
  while true; do
    if [ ! "$(adb shell getprop sys.boot_completed | tr -d '\r')" = "1" ]; then # Based on https://stackoverflow.com/a/38896494
      echo "Device off!"
      break
    fi
    i=$((i + 1))
    if [ "$i" -eq 300 ]; then
      echo "Constant signal from adb device after 5 minutes"
      exit 1
    fi
    sleep 1
  done
}

waitForDevice
adb shell magisk --remove-modules
waitForDeviceOff
waitForDevice
rimraf "$here/dist"
"C:/Program Files/7-Zip/7z" a "$here/dist/magisk-module-mitmproxy-cert-debug.zip" "$here"/src/**
retry adb shell ls \$EXTERNAL_STORAGE/Download
adb push "$here/dist/magisk-module-mitmproxy-cert-debug.zip" //sdcard/Download
adb shell "rm -rf /data/magisk-module-mitmproxy-cert"
adb shell "magisk --install-module \$EXTERNAL_STORAGE/Download/magisk-module-mitmproxy-cert-debug.zip"
adb shell "rm \$EXTERNAL_STORAGE/Download/magisk-module-mitmproxy-cert-debug.zip"
waitForDevice
sleep 60
if [ -d "$here/temp/logs" ]; then
  rm -rf "$here/temp/logs"
fi
mkdir --parents "$here/temp/logs"
adb shell ls /cache/\*.log | tr -d '\r' | xargs -I_ adb pull /_ "$here/temp/logs"
adb shell ls /cache/\*.txt | tr -d '\r' | xargs -I_ adb pull /_ "$here/temp/logs"
adb shell ls /data/magisk-module-mitmproxy-cert/\*.txt | tr -d '\r' | xargs -I_ adb pull /_ "$here/temp/logs"
adb logcat dump -t 10000 \*:V >"$here/temp/logs/logcat.log"
adb logcat dump -t 20000 \*:V -b all | grep magisk-module-mitmproxy-cert >"$here/temp/logs/mylog.log"
adb shell env >"$here/temp/logs/.env"

adb shell ls \$ANDROID_ROOT/etc/security/cacerts | wc -l
