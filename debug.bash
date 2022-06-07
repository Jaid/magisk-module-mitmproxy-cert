#!/usr/bin/env bash
set -e
set -o errexit

source ./retry.bash

here="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)"

function waitForHeartbeat() {
  retry adb shell "ping -c 1 127.0.0.1"
}

waitForHeartbeat
adb shell magisk --remove-modules
sleep 60
waitForHeartbeat
rimraf $here/src
"C:/Program Files/7-Zip/7z" a $here/dist/magisk-module-mitmproxy-cert.zip $here/magisk-module-mitmproxy-cert/**
retry adb shell ls \$EXTERNAL_STORAGE/Download
adb push $here/magisk-module-mitmproxy-cert.zip //sdcard/Download
adb shell "magisk --install-module \$EXTERNAL_STORAGE/Download/magisk-module-mitmproxy-cert.zip"
waitForHeartbeat
# adb shell ls \$EXTERNAL_STORAGE/Download | grep mitm
# adb shell ls \$ANDROID_ROOT/etc/security/cacerts | wc -l
sleep 60
rimraf $here/temp/logs
mkdir --parents $here/temp/logs
adb shell ls \/cache/\*.log | tr -d '\r' | xargs -I_ adb pull /_ $here/temp/logs
adb shell ls \/cache/\*.txt | tr -d '\r' | xargs -I_ adb pull /_ $here/temp/logs
adb logcat dump -t 10000 \*:V >$here/temp/logs/logcat.log
adb logcat dump -t 20000 \*:V -b all | grep magisk-module-mitmproxy-cert >$here/temp/logs/mylog.log
adb shell env >$here/temp/logs/.env
