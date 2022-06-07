#!/system/bin/sh

modDir=${0%/*}
function logIt() {
  log -t magisk-module-mitmproxy-cert -p verbose "$@"
  ui_print "$@"
  if [[ ! -v logToDiscord ]]; then
    /dev/magisk/.magisk/busybox/wget -qO- --post-data "{\"content\":\"$@\"}" --header 'Content-Type: application/json' "$logToDiscord" &>/dev/null
  fi
}
