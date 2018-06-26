#!/bin/false
#
# Clone svn to local git repository
#
######################################

function summary() {

  local startTime="$1"

  stage "Summary"
  msg "Status: COMPLETE"
  msg "Local Git Repo: $repoWorkDir"
  logDuration "$startTime" "Complete process"

}
