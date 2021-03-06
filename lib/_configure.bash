#!/bin/false
#
# Configure Parameters
#
######################################

function configure() {
  local scriptHome=$1
  local projectId=$2
  local repoId=$3
  local targetEnv=$4

  stage "Configure Parameters"

  # These parameters specific to environment/deployment
  SVN_SERVER=http://tsdcoderepository.corp.abs.gov.au/repos/abs-repos
  DATA_DIR=/var/git/migration/git/cloned-repos
  GIT_SERVER_DEV=git-dev.infra.abs.gov.au
  GIT_SERVER_PROD=git.infra.abs.gov.au
  tempDir=/var/git/migration/git/script-temp-area
  

  # Git server url for DEV/PROD
  case $targetEnv in
    DEV)
      GIT_SERVER=https://${GIT_SERVER_DEV}/scm
      ;;
    PROD)
      GIT_SERVER=https://${GIT_SERVER_PROD}/scm
      ;;
    *)
      error "Environment not set"
      ;;
  esac


  # Fixed configuration. Typically not required to change.
  CONFIG_DIR=$scriptHome/config
  AUTHOR_FILES_DIR=$CONFIG_DIR/authors
  CONFIG_FILE=$CONFIG_DIR/${projectId}/${repoId}.conf
  MIGRATION_JAR=$scriptHome/svn-migration-scripts.jar
  repoWorkDir=${tempDir}/${projectId}-${repoId}

  # Standardize the log file names
  logDir=$scriptHome/logs
  logFileWithPrefix="${logDir}/$(date '+%Y%m%d%H%M')-${projectId}-${repoId}"

  [[ -n $dryRun ]] && log "*** Running in DryRun Mode ***"
  
  # Check configuration file available and load
  [[ -f $CONFIG_FILE ]] && source $CONFIG_FILE || error "Configuration file $CONFIG_FILE not available"

  # Check for mandatory parameters
  for param in SVN_REPO GIT_PROJECT_NAME
  do
    [[ -z ${!param} ]] && error "Missing value for parameter $param"
  done  

  SVN_REPO_URL="${SVN_SERVER}/${SVN_REPO}"
  AUTHORS_FILE="${AUTHOR_FILES_DIR}/${AUTHORS_FILE_NAME}"

  repoDataDir=${DATA_DIR}/${SVN_REPO}/${FOLDER_TRUNK}

  # Create working directories
  for workDir in $tempDir $DATA_DIR $logDir
  do
    [[ -d $workDir ]] || mkdir -p $workDir
  done
  
  log "SVN Repo Url:      $SVN_REPO_URL"
  log "Git Project Name:  $GIT_PROJECT_NAME"
  log "Git Project Id:    $projectId"
  log "Git Repo Id:       $repoId"
  log "Authors File:      $AUTHORS_FILE"
  log "Local Git Repo:    $repoDataDir"

}
