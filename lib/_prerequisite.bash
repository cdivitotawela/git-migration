#!/bin/false
#
# Check Prerequisite 
#
######################################

function prerequisite() {
  local scriptHome=$1

  stage "Checking Perequisite"

  which java > /dev/null 2>&1 && success "Java available" || error "Java not found"
  which git > /dev/null 2>&1 && success "Git available"|| error "Git not found"
  which svn > /dev/null 2>&1 && success "Svn client available" || error "Svn client not found"

  if [[ -f $MIGRATION_JAR ]]
  then
    java -jar $MIGRATION_JAR verify || error "Verification by migration jar script failed"
  fi
}
