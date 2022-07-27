#!/usr/bin/env ash
set -e
set -o errexit

function retry() {
  declare red='\033[0;31m'
  declare noColor='\033[0m'
  declare sleepTimes=(
    0.5
    2
    5
    20
    60
  )
  i=0
  while true; do
    "$@" && break
    declare fullSleep=${sleepTimes[$i]}
    echo -n -e "${red}Code $?, retrying in ${sleepTimes[$i]} seconds$noColor"
    # thirdSleep=$((${fullSleep} / 3)) # Only in zsh
    declare thirdSleep
    thirdSleep=$(node -pe "${fullSleep}/3")
    sleep "$thirdSleep"
    echo -n -e "."
    sleep "$thirdSleep"
    echo -n -e "."
    sleep "$thirdSleep"
    echo -e "."
    declare i
    i=$(expr $i + 1)
    if [ "$i" -eq "${#sleepTimes[@]}" ]; then
      echo -e "${red}Giving up!$noColor"
      break
    fi
  done
}
