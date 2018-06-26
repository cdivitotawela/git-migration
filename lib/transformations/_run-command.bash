#!/bin/false

function run-command() {

  local workDir="$1"
  local transform="$2"
  local logFile="${logFileWithPrefix}-${transform}-run-command.log"

  commandParam=${transform}_COMMAND
  command=${!commandParam}

  [[ -z $command ]] && error "Parameter $commandParam need to be defined"

  [[ -z $dryRun ]] && cd $workDir
  msg "Command log file $commandLogFile" 
  if [[ -z $dryRun ]] 
  then
    eval $command > $logFile 2>&1 || error "Error occurred running command [$command]"
  fi
}
