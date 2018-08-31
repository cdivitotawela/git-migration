#!/bin/false

function filter-branches() {

  local workDir="$1"
  local transform="$2"
  local logFile="${logFileWithPrefix}-${transform}-filter-branches.log"

  # Should be either RETAIN or DELETE
  filterTypeParam=${transform}_FILTER_TYPE
  filterType=${!filterTypeParam}

  # Comma separated list of branches to retain or delete
  branchesListParam=${transform}_BRANCHES_LIST
  branchesList=${!branchesListParam}  

  # Validate the filterType set and correctly set
  [[ -z $filterType ]] && error "Parameter $filterTypeParam need to be defined"
  [[ $(echo $filterType | egrep -s '^DELETE$|^RETAIN$') ]] || error "Parameter $filterTypeParam need to have either DELETE or RETAIN"

  # Validate whether list of branches are specified
  [[ -z $branchesList ]] && error "Parameter $branchesList need to be defined"

  cd $workDir

  msg "Log file $logFile" 
  msg "Filter type is $filterType"

  # Delete only the tags specified
  if [[ $filterType == 'DELETE' ]]
  then
    # Lets not allow deleting the master branch. Once the git repository is created it will be on master branch
    # Even if we want to delete the master branch we cannot delete unless we checkout another branch
    [[ $(echo $branchesList | grep -c master) -ne 0 ]] && error "Cannot delete branch master"

    for deleteBranch in $(echo $branchesList | sed 's/,//')
    do
      git branch -D $deleteBranch >> $logFile || error "Failed to delete branch $deleteBranch"
    done
  fi  

  # Retain specified branches and delete others
  if [[ $filterType == 'RETAIN' ]]
  then
    # Exclude the master branch from the list of branches
    for branchName in $(git branch --list | egrep -v "\s+master")
    do
      if [[ $(echo $branchesList | grep -c $branchName) -eq 0 ]]
      then
        branch -D $branchName >> $logFile || error "Failed to delete branch $deleteBranch"
      fi
    done
  fi

}
