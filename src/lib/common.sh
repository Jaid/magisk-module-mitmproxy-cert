#!/system/bin/sh
set -e
set -o errexit

modDir=${0%/*}
logIt() {
  log -t magisk-module-mitmproxy-cert -p verbose "$@"
  ui_print "$@"
  if [ -n "${logToDiscord}" ]; then
    /dev/magisk/.magisk/busybox/wget -qO- --post-data "{\"content\":\"$*\"}" --header 'Content-Type: application/json' "$logToDiscord" >/dev/null 2>&1
  fi
}
