#!/bin/bash

# This script will push SonarQube issues to the Github PR.
# Cirle CI usage: REPOSITORY_PATH="PATH" BRANCH=$CIRCLE_BRANCH ./sonarqube_relay_feedback_on_pr.sh

__DIR__=${__DIR__:=$(dirname "$0")}

. "$__DIR__/../src/service/utils.sh"
. "$__DIR__/../config.sh"
. "$__DIR__/../src/service/validate_globals.sh"
. "$__DIR__/../src/service/github_delete_issue_comment.sh"
. "$__DIR__/../src/service/github_post_pr_message.sh"
. "$__DIR__/../src/service/sonarqube_get_feedback_for_pr.sh"
. "$__DIR__/../src/service/github_pr_comments.sh"
. "$__DIR__/../src/service/github_pr_files.sh"

isset "REPOSITORY_PATH must be set." $REPOSITORY_PATH
isset "BRANCH must be set." $BRANCH

PR=$(getBranchPr $BRANCH)

if [[ $PR == 0 || -z $PR ]]; then
	echo "PR for branch '$BRANCH' not found."
	exit 1
fi

PR_NUMBER=$(getPrNumberFromPrUrl $PR)

echo 'Retrieving existing pull request comments'
pr_comments_response=$(getPrDiffComments $PR_NUMBER)

if [[ $pr_comments_response != '[ ]' ]]; then
	echo 'Removing existing diff comments'
	deleteDiffComments "$pr_comments_response"
fi

echo 'Retrieving SonarQube feedback for issues raised'
feedback=$(getSonarQubeLastRunIssuesFeedback)

issues=$(echo $feedback | jq '.issues')

echo "ISSUES: $issues"

if [[ $(echo $issues | jq length) -eq 0 ]]; then
	echo 'No issues found.'
else
	echo 'Dispatching comments to github'
	commentOnDiffs "$PR_NUMBER" "$issues"
fi
