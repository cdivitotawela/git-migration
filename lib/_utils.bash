#!/bin/false

log() {
  echo -e "$1"
}

stage() {
  log "\n*******************************************"
  log "\e[96m$1\e[0m"
  log "*******************************************"
}

error() {
  log "\e[91m$1\e[0m"
  exit 1
}

msg() {
  log "\e[1m$(date '+%Y-%m-%d %H:%M:%S') $1\e[0m"
}

success() {
  echo -e "  \e[92m* ${1}\e[0m"
}

getPatameterValue() {
  local parameter="$1"
  local value="${!parameter}"

  [[ -z $value ]] && error "Parameter $parameter need to be defined"
  echo "$value"
}

getTimeEpoch() {
  date '+%s'
}

logDuration() {
  local statTime="$1"
  local logMessage="$2"

  # Validate start time is not empty 
  [[ -z $statTime ]] && error "Start time not set"

  # Calculate elapsed time
  local duration=$(expr $(getTimeEpoch) - $statTime)

  msg "${logMessage} took \e[95m${duration}s\e[0m" 
}

