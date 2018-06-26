#!/bin/false

function delete-file-or-directory() {

  local workDir="$1"
  local transform="$2"
  local logFile=${logFileWithPrefix}-${transform}-delete-file.log

  # File or directory name should contain path starting from repo root
  # Ex: rootFolder/subFolder/filename
  fileNameParam="${transform}_FILE_OR_DIRECTORY"
  fileName=${!fileNameParam}
  [[ -z $fileName ]] && error "Value required for $fileNameParam"  

  msg "Log file $logFile"
  if [[ -z $dryRun ]]
  then
    git filter-branch -f --index-filter "git rm -r --cached --ignore-unmatch \"${fileName}\"" HEAD > $logFile 2>&1 || error "Filter execution failed"
  fi
}
