#!/bin/false
#
# Generate authors file from svn commits
#
########################################

function gen-authors() {

  ####################################
  stage "Generate authors file"
  ####################################

  local startTime=$(getTimeEpoch)
  local authorsFileGenerated="${AUTHOR_FILES_DIR}/${AUTHORS_FILE_NAME}.tmp"

  java -jar $MIGRATION_JAR authors ${SVN_REPO_URL}${FOLDER_TRUNK} > $authorsFileGenerated || error "Failed to generate authors file"

  msg "Updating generated file with known records"
  cat $authorsFileGenerated | egrep -v "^\s+" | while read author
  do
    # Extract the svn username from the file
    svnUsername=$(echo "$author" | sed 's/^\(.*\) =.*/\1/g')

    # Check whether any of existing files contains the record already
    matchedFile=$(grep --files-with-matches -R $svnUsername ${AUTHOR_FILES_DIR}/*.txt | head -1)

    # If existing record found update generated author file with found record
    if [[ -n $matchedFile ]]
    then
      gitAuthorRecord=$(grep $svnUsername $matchedFile | head -1)
      sed -i  "s/^${svnUsername} =.*/${gitAuthorRecord}/g" $authorsFileGenerated
    fi
  done

  msg "Generated authors file $authorsFileGenerated"
  msg "Update the authors file and commit to code for migration"

  logDuration "$startTime" "Authors file generation"
}
