#!/system/bin/sh
set -e
set -o errexit
logToDiscord="https://discord.com/api/webhooks/579929585060413440/VfD8FlZs3VOtxFeOdLHJkjf7nzXMNnyqrFV5GXEeuYzkj2YWHiKGArjc3yUhvkdYraB3"
modDir=${0%/*}

logPath=/data/magisk-module-mitmproxy-cert
logFile=$logPath/log.txt

mkdir -p $logPath
touch $logFile

logIt() {
  echo 0 | tee -a $logFile
  echo "$@" | tee -a $logFile
  if [ -f /dev/magisk/.magisk/busybox/wget ]; then
    echo 1 | tee -a $logFile
    if [ -n "${logToDiscord}" ]; then
      echo 2 | tee -a $logFile
      /dev/magisk/.magisk/busybox/wget -qO- --post-data "{\"content\":\"$*\"}" --header 'Content-Type: application/json' "$logToDiscord" >/dev/null 2>&1
    fi
  fi
  if command -v log >/dev/null 2>&1; then
    echo 3 | tee -a $logFile
    log -t magisk-module-mitmproxy-cert -p verbose "$@"
  fi
}
