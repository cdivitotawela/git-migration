#!/bin/false
#
# Prepare working repository
#
######################################

function push-remote() {

  local startTime=$(getTimeEpoch)
  
  cd $repoWorkDir || error "Cannot change to work repo $repoWorkDir"

  # Remove existing origin
  git remote remove origin || error "Failed to remove origin"

  # Add origin 
  git remote add origin $GIT_SERVER/${projectId}/${repoId}.git

}
