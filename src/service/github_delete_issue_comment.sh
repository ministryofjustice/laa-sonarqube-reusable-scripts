#!/bin/bash

# This script is meant to delete comments on github issues. Issues are very broad category on github which include pull requests.

# Test variable setup.
# CIRCLE_PROJECT_USERNAME=ministryofjustice
# CIRCLE_PROJECT_REPONAME=laa-ccms-pui

# Param 1 should be a list of comments in JSON from github.
deleteComments() {
  for row in $(printf "${1}" | jq -r '.[] | @base64'); do
    OWNER=$(_jq "$row" '.user.login')
    MESSAGE=$(_jq "$row" '.body')
    MESSAGE_ID=$(_jq "$row" '.id')
    IS_BOT_MESSAGE=$(echo $MESSAGE | grep -e "^SONARQUBE BOT MSG - .*" )

    if [[ $IS_BOT_MESSAGE != "" ]]; then
      deleteComment $MESSAGE_ID
    fi
  done
}

deleteComment() {
  echo 'delete comment '$1

  callGithub DELETE "/repos/$REPOSITORY_ORGANISATION/$REPOSITORY_NAME/issues/comments/$1"
}

deleteDiffComments() {
  for row in $(echo "${1}" | jq -r '.[] | @base64'); do
    MESSAGE=$(_jq "$row" '.body')
    MESSAGE_ID=$(_jq "$row" '.id')
    IS_BOT_MESSAGE=$(echo $MESSAGE | grep -e "^\[SONARQUBE BOT ISSUE\].*" )

    if [[ $IS_BOT_MESSAGE != "" ]]; then
      deleteDiffComment $MESSAGE_ID
    fi
  done
}

deleteDiffComment() {
  echo 'delete comment '$1

  callGithub DELETE "/repos/$REPOSITORY_ORGANISATION/$REPOSITORY_NAME/pulls/comments/$1"
}
