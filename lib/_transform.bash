#/bin/false!
#
# Apply Transformations
#
######################################


function transform() {


  ####################################
  stage "Transforming"
  ####################################

  # Max 19 transformations applied
  for indx in {1..19}
  do
    transformParam=TRANSFORM_${indx}_TYPE
    transformType=${!transformParam}
    if [[ -n $transformType ]]
    then
      type $transformType >/dev/null 2>&1 || error "Transformation type [$transformType] no defined"

      local startTime=$(getTimeEpoch)
    
      # Navigate to working repo and validate its a git repo
      [[ -z $dryRun ]] && cd $repoWorkDir
      [[ -z $dryRun ]] && [[ -d $repoWorkDir/.git ]] || error "No git repository $workDir"   

      msg "Applying transformation [TRANSFORM_${indx}] : [$transformType] on repo [$repoWorkDir]"
      $transformType "$repoWorkDir" "TRANSFORM_${indx}"

      logDuration "$startTime" "Transformation [TRANSFORM_${indx}]"
    fi
  done
  
}
