#!/bin/false

# Move/Rename File or Directory
function move-directory() {

  local workDir="$1"
  local local transform="$2"
  local logFile=${logFileWithPrefix}-${transform}-move-directory.log

  fromDirParam="${transform}_FROM_DIRECTORY"
  fromDir=${!fromDirParam}
  [[ -z $fromDir ]] && error "Value required for $fromDirParam"

  toDirParam="${transform}_TO_DIRECTORY"
  toDir=${!toDirParam}
  [[ -z $toDir ]] && error "Value required for $toDirParam"

  msg "Log file [$logFile]"
  if [[ -z $dryRun ]]
  then
    git filter-branch -f --tree-filter "test -d \"${fromDir}\" && mv \"${fromDir}\" ${toDir} || echo 'skip directory not found'" HEAD > $logFile 2>&1 || error "Error occurred running filter $filterName"
  fi
}
