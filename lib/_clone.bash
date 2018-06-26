#!/bin/false
#
# Clone svn to local git repository
#
######################################

function clone() {


  ####################################  
  stage "SVN Rpository Clone"
  ####################################

  local logFile="${logFileWithPrefix}-svn-clone.log"
  local startTime=$(getTimeEpoch)

  msg "SVN-Git Clone log file $logFile"

  # Check whether autors file exist
  [[ -r $AUTHORS_FILE ]] || error "Authors file $AUTHORS_FILE either not available or not readable"

  # Explicitly set the trunk folder. Default is /trunk  
  if [[ -n $FOLDER_TRUNK ]]
  then
    trunkFolder="--trunk=${FOLDER_TRUNK}"
  else
    trunkFolder="--trunk=/trunk"
  fi
 
  # Adding list of branches to migrate
  for branch in $(echo $FOLDER_BRANCHES | sed 's/,/ /g')
  do
    branchFolders="${branchFolders} --branches=${branch}"
  done

  # Adding list of tags to migrate
  for tag in $(echo $FOLDER_TAGS | sed 's/,/ /g')
  do
    tagFolders="${tagFolders} --tags=${tag}"
  done

  # Set the revision number to start from
  [[ -n $START_REVISION ]] && startRevision="-r ${START_REVISION}:HEAD"

  # TODO: Not currently used
  if [[ -n $INCLUDE_PATHS ]]
  then
    for includePath in $(echo $INCLUDE_PATHS | sed 's/,/ /g')
    do
      includePaths="${includePaths}|${includePath}"
    done
    includePaths="--include-paths=$(echo "$includePaths" | sed "s/^|//g")"
  fi


  # Delete existing folder if cleanMigration parameter set
  if [[ -z $dryRun ]]
  then
    if [[ $cleanMigration ]]
    then
      if [[ -d $repoDataDir ]] 
      then
        msg "Clean existing local cloned git at $repoDataDir" 
        rm -rf $repoDataDir
      fi
    fi 
  fi


  # If local clone already exit only update if not perform full clone
  if [[ -d $repoDataDir ]]
  then
    msg "Local Git repository seems available so fetch changes"
    cd $repoDataDir
    $dryRun git svn fetch $startRevision $includePaths >$logFile 2>&1 || error "Git SVN fetch failed"
    $dryRun git svn rebase >>$logFile 2>&1 || error "Git SVN rebase failed"
  else
    msg "Creating local Git repository"
    $dryRun git svn clone $trunkFolder $branchFolders $tagFolders $includePaths --prefix "" --authors-file=$AUTHORS_FILE --no-minimize-url $startRevision "$SVN_REPO_URL" $repoDataDir >$logFile 2>&1 || error "SVN-Git clone failed"
  fi

  if [[ -z $dryRun ]]
  then
    # Note: Remote branches need to be converted to local branches otherwise work repo clone will not have branches.
    #       Convert all remote branches to local but don't delete any remote branches as those are required to receive updates
    #       Any existing local branches delete and recreated from remote branches. May be it might not need to re-recreate the branches
    #       branches may get updates automatically.

    cd $repoDataDir || error "Error changing to $repoDataDir"

    # Delete any local branches apart from master
    for localBranch in $(git branch --list | grep -v "master")
    do
      git branch -D $localBranch || error "Failed deleting local branch $localBranch"
    done

    # Convert remote branches to local branches
    for branch in $(git for-each-ref --format='%(refname:short)' refs/remotes/ | grep -v trunk )
    do
      msg "Converting branch $branch to local"
      git branch $branch refs/remotes/$branch >>$logFile 2>&1 || error "Failed converting remote branch $branch"
    done
  fi

  logDuration "$startTime" "SVN Git clone"
}
