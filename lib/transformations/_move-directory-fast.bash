#!/bin/false

# Move/Rename File or Directory
function move-directory-fast() {

  local workDir="$1"
  local transform="$2"
  local logFile=${logFileWithPrefix}-${transform}-move-directory-fast.log

  fromDirParam="${transform}_FROM_DIRECTORY"
  fromDir=${!fromDirParam}
  [[ -z $fromDir ]] && error "Value required for $fromDirParam"

  toDirParam="${transform}_TO_DIRECTORY"
  toDir=${!toDirParam}
  [[ -z $toDir ]] && error "Value required for $toDirParam"

  msg "Log file [$logFile]"
  if [[ -z $dryRun ]]
  then
    eval "git filter-branch -f --index-filter 'git ls-files -s | sed \"s|${fromDir}|${toDir}|\" | GIT_INDEX_FILE=\"\$GIT_INDEX_FILE.new\" git update-index --index-info && [[ -f \"\$GIT_INDEX_FILE.new\" ]] && mv \"\$GIT_INDEX_FILE.new\" \"\$GIT_INDEX_FILE\" || echo "skip commit"' --prune-empty  HEAD > $logFile 2>&1 || error \"Failed in transformation\"" 
  fi
}
