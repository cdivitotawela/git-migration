#!/bin/false

# Move a sub-folder to root folder
function extract-sub-folder() {

  local workDir="$1"
  local transform="$2"
  local logFile=${logFileWithPrefix}-${transform}-extract-sub-folder.log

  folderNameParam="${transform}_DIRECTORY"
  folderName=${!folderNameParam}
  [[ -z folderName ]] && error "Value required for $folderNameParam"  

  msg "Log file $logFile"
  if [[ -z $dryRun ]]
  then
    git filter-branch -f --subdirectory-filter "$folderName" -- --all >$logFile 2>&1 || error "Error performing transform $transform"
  fi
} 
