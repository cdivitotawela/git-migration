#!/bin/false

function filter-tags() {

  local workDir="$1"
  local transform="$2"
  local logFile="${logFileWithPrefix}-${transform}-filter-tags.log"

  # Should be either RETAIN or DELETE
  filterTypeParam=${transform}_FILTER_TYPE
  filterType=${!filterTypeParam}

  # Comma separated list of tags to retain or delete
  tagListParam=${transform}_TAG_LIST
  tagList=${!tagListParam}

  [[ -z $filterType ]] && error "Parameter $filterTypeParam need to be defined"
  [[ $(echo $filterType | egrep -s '^DELETE$|^RETAIN$') ]] || error "Parameter $filterTypeParam need to have either DELETE or RETAIN"
  [[ -z $tagListParam ]] && error "Parameter $tagListParam need to be defined"

  cd $workDir

  msg "Log file $logFile" 
  msg "Filter type is $filterType"

  local existingTags=
  local tagsToDelete=

  # Collect tags to a single line
  for tag in $(git tag)
  do
    existingTags="$existingTags $tag"
  done

  # Delete only the tags specified
  if [[ $filterType == 'DELETE' ]]
  then
    for tagToDelete in $(echo $tagList | sed 's/,/ /')
    do
      git tag -d $tagToDelete >> $logFile || error "Failed to delete tag $tagToDelete" 
    done
  fi 

  # Delete all tags that not in tag list
  if [[ $filterType == 'RETAIN' ]]
  then
    for currentTag in $existingTags
    do
      if [[ $(echo $tagList | grep -c $currentTag) -eq 0 ]]
      then
        git tag -d $currentTag >> $logFile || error "Failed to delete tag $currentTag"
      fi
    done
  fi

}
