#!/bin/bash

# This script is meant to delete old sonar reports from a pull requests.
# Cirle CI usage: PULL_REQUEST_URL=$CIRCLE_PULL_REQUEST ./github_delete_summary_from_pr.sh

__DIR__="$(dirname "$0")"

. "$__DIR__/../service/utils.sh"
. "$__DIR__/../../config.sh"
. "$__DIR__/../service/validate_globals.sh"
. "$__DIR__/../service/github_pr_comments.sh"
. "$__DIR__/../service/github_delete_issue_comment.sh"

isset "PULL_REQUEST_URL must be set." $PULL_REQUEST_URL

echo 'Deleting existing SonarQube summary if exists.'
pr_comments_response=$(getPrComments ${PULL_REQUEST_URL##*/})
deleteComments "$pr_comments_response"
