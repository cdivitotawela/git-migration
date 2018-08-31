#!/bin/false

function move-to-sub-folder() {

  local workDir="$1"
  local transform="$2"
  local logFile="${logFileWithPrefix}-${transform}-move-to-subfolder.log"

  # Extract subfolder name
  subFolderParam=${transform}_SUBFOLDER
  subFolder=${!subFolderParam}

  [[ -z $subFolder ]] && error "Parameter $subFolderParam need to be defined"

  msg "Moving the root to subfolder $subFolder"
  if [[ -z $dryrun ]] 
  then
    eval "git filter-branch --index-filter 'git ls-files -s | sed \"s-\t\\\"*-&${subFolder}/-\" | GIT_INDEX_FILE=\$GIT_INDEX_FILE.new git update-index --index-info &&  mv \"\$GIT_INDEX_FILE.new\" \"\$GIT_INDEX_FILE\"' HEAD >$logFile 2>&1 || error \"Error occurred performing transformation ${transform}\""
  fi
}
