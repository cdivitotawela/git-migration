#!/bin/bash
#
# Svn-Git Migration Automation
#
###########################################

clear

# Locate the script home directory
if [[ $(dirname $0) == "." ]]
then
  scriptHome=$(pwd)
else
  scriptHome=$(dirname $0)
fi

# Source library files
for lib in $(find $scriptHome/lib -name _*.bash -type f)
do
  source $lib
done

# Start message
scriptStartTime=$(getTimeEpoch)
msg "Starting Git Migration"

usage() {
  cat <<EOM
Usage: $(basename $0) [OPTIONS]
  -o VALUE   Operation to perform.(Required Parameter)
               GENAUTHORS: generate authors file
               MIGRATE: migrate to git in local disk
  -b         Bitbucket project id
  -r         Bitbucket repository id
  -e         Environment DEV/PROD. Default to DEV
  -i         Corp username
  -d         Dry run. Echo commands
  -c         Perform clean migration delting the existing clone
  -h         Display help
EOM
  exit 0
}


# Command line parameter parsing
while getopts "o:b:r:i:e:pdc" optKey
do
  case $optKey in
    o)
      operation=$OPTARG
      [[ $(echo $operation | egrep -c '^GENAUTHORS$|^MIGRATE$') -ne 1 ]] && error "Operation should be one of GENAUTHORS"
      ;;
    b)
      projectId=$OPTARG
      ;;
    r)
      repoId=$OPTARG
      ;;
    e)
      targetEnv=$OPTARG
      ;;
    p)
      echo -n "Enter the password for user $corpUsername: "
      read -s corpPassword
      if [[ -z $corpPassword ]]
      then
        echo
        error "Password empty. Cannot proceed"
      fi
      clear
      ;;
    i)
      corpUsername=$OPTARG
      ;;
    d)
      dryRun="echo SIMULATE : "
      ;;
    c)
      cleanMigration=true
      ;;
    h|*)
      usage
      ;;
  esac
done

shift $((OPTIND - 1))

# Check all required parameters provided
[[ -z $operation ]]    && error "Missing operation parameter"
[[ -z $projectId ]]    && error "Missing Bitbucket project id"
[[ -z $repoId ]]       && error "Missing Bitbucket repository id"

# If environment not set default to DEV
targetEnv=${targetEnv:-DEV}

[[ -n $dryRun ]] && {
  log "******************************"
  log "*** Running in DryRun Mode ***"
  log "******************************"
}

# Configure script parameters
configure "$scriptHome" "$projectId" "$repoId" "$targetEnv"

# Check prerequisites
prerequisite 

case $operation in
  GENAUTHORS)
    gen-authors
  ;;
  MIGRATE)
    clone
    prepare-work-repo
    transform 
    push-remote
  ;;
esac

# Display summary report
summary "$scriptStartTime"
