#!/bin/false
#
# Prepare working repository
#
######################################

function prepare-work-repo() {

  ####################################
  stage "Copy repo to work directory"
  ####################################

  local startTime=$(getTimeEpoch)
  local logFile="${logFileWithPrefix}-prepare-work-repo.log"
  msg "Prepare work repo log file $logFile"

  # Delete existing working copy
  msg "Working repo $repoWorkDir"
  if [[ -d $repoWorkDir ]]
  then
    rm -rf $repoWorkDir || error "Error deleting existing work repo"
  fi

  # Perform simple copy
  msg "Setup working repo at [$repoWorkDir]"
  if [[ -z $dryRun ]]
  then
    git clone $repoDataDir $repoWorkDir >$logFile 2>&1 || error "Error clone to work repo"
  fi
  msg "Complete copying working repo"

  if [[ -z $dryRun ]]
  then
    # Change the directory to working repository
    cd $repoWorkDir || error "Could not change to directory $repoWorkDir"

    # Move remote branches to local branches
    msg "Convert remote branches to local"
    for ref in $(git for-each-ref --format='%(refname:short)' refs/remotes/origin/ | grep -v HEAD | grep -v master | grep -v @)
    do
      local branchName=$(echo $ref | sed 's|origin/||g')
      msg "Converting branch $branchName"
      git branch $branchName refs/remotes/$ref && git branch -D -r $ref >>$logFile 2>&1 || error "Failed converting remote branch $branchName"
    done
  fi

  msg "Convert remote tags to local tags"
  for t in $(git for-each-ref --format='%(refname:short)' refs/remotes/tags)
  do
    git tag ${t/tags\//} $t && git branch -D -r $t >>$logFile 2>&1 || error "Failed converting remote tags"
  done
 
  logDuration "$startTime" "Prepare work repository"
}
