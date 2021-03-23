#!/bin/bash

# This script is meant to delete old sonar reports from a pull requests.
# Cirle CI usage: BRANCH=$CIRCLE_BRANCH ./github_delete_summary_from_pr.sh

__DIR__=${__DIR__:=$(dirname "$0")}

. "$__DIR__/../src/service/utils.sh"
. "$__DIR__/../config.sh"
. "$__DIR__/../src/service/validate_globals.sh"
. "$__DIR__/../src/service/github_pr_comments.sh"
. "$__DIR__/../src/service/github_delete_issue_comment.sh"
. "$__DIR__/../src/service/github_post_pr_message.sh"

isset "BRANCH must be set." $BRANCH

PR=$(getBranchPr $BRANCH)

if [[ $PR == 0 || -z $PR ]]; then
	echo "PR for branch '$BRANCH' not found."
	exit 1
fi

PR_NUMBER=$(getPrNumberFromPrUrl $PR)

echo 'Deleting existing SonarQube summary if exists.'
pr_comments_response=$(getPrComments $PR_NUMBER)
deleteComments "$pr_comments_response"
