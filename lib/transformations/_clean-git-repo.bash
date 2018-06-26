#!/bin/false

# Clean git repository
function clean-git-repo() {

  local workDir="$1"
  local local transform="$2"
  local logFile="${logFileWithPrefix}-${transform}-clean-git.log"

  msg "Log file [$logFile]"
  git filter-branch -f --msg-filter 'sed -e"/^git-svn-id:/d"' > $logFile 2>&1 || error "Failed while removing the git-svn-id"

}
