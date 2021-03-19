#!/bin/bash

# This script will push SonarQube issues to the Github PR.
# Cirle CI usage: REPOSITORY_PATH="PATH" PULL_REQUEST_URL=$CIRCLE_PULL_REQUEST ./sonarqube_relay_feedback_on_pr.sh

__DIR__="$(dirname "$0")"

. "$__DIR__/../service/utils.sh"
. "$__DIR__/../../config.sh"
. "$__DIR__/../service/validate_globals.sh"
. "$__DIR__/../service/github_delete_issue_comment.sh"
. "$__DIR__/../service/github_post_pr_message.sh"
. "$__DIR__/../service/sonarqube_get_feedback_for_pr.sh"
. "$__DIR__/../service/github_pr_comments.sh"

isset "REPOSITORY_PATH must be set." $REPOSITORY_PATH 
isset "PULL_REQUEST_URL must be set." $PULL_REQUEST_URL

echo 'Retrieving existing pull request comments'
pr_comments_response=$(getPrDiffComments ${PULL_REQUEST_URL##*/})

if [[ $pr_comments_response != '[ ]' ]]; then
	echo 'Removing existing diff comments'
	deleteDiffComments "$pr_comments_response"
fi

echo 'Retrieving SonarQube feedback for issues raised'
feedback=$(getSonarQubeLastRunIssuesFeedback)

issues=$(echo $feedback | jq '.issues')

if [[ $issues != '' ]]; then
	echo 'Dispatching comments to github'
	commentOnDiffs "${PULL_REQUEST_URL##*/})" "$issues"
else
	echo 'No issues found.'
fi
