#!/bin/bash

# This script is meant to delete old sonar reports from a pull requests
# Cirle CI usage: BRANCH=$CIRCLE_BRANCH PULL_REQUEST_URL=$CIRCLE_PULL_REQUEST ./github_post_sonarqube_summary.sh
# Optional vars - NEW_CDOE=1, OLD_CODE=0

__DIR__="$(dirname "$0")"

. "$__DIR__/../src/service/utils.sh"
. "$__DIR__/../config.sh"
. "$__DIR__/../src/service/validate_globals.sh"
. "$__DIR__/../src/service/github_pr_comments.sh"
. "$__DIR__/../src/service/github_delete_issue_comment.sh"
. "$__DIR__/../src/service/github_post_pr_message.sh"
. "$__DIR__/../src/service/sonarqube_get_feedback_for_pr.sh"
. "$__DIR__/../src/service/sonarqube_produce_analysis_summary.sh"

isset "BRANCH must be set." $BRANCH
isset "PULL_REQUEST_URL must be set." $PULL_REQUEST_URL

echo 'Deleting existing SonarQube summary if exists.'
pr_comments_response=$(getPrComments ${PULL_REQUEST_URL##*/})
deleteComments "$pr_comments_response"

SONAR_SUMMARY=$(quality_gate_metrics)
if [[ $NEW_CODE == 1 ]]; then
	SONAR_SUMMARY="$SONAR_SUMMARY"$(new_code_summary)
fi

if [[ $OLD_CODE == 1 ]]; then
	SONAR_SUMMARY="$SONAR_SUMMARY"$(existing_code_summary)
fi

PAYLOAD="SONARQUBE BOT MSG - [SonarQube analysis report]($SONARQUBE_URL/dashboard?id=$SONARQUBE_COMPONENT_ID). <br /><br />:zap: Summary $SONAR_SUMMARY"

echo 'Send updated summary'
sendPrMessage "$BRANCH" "$PAYLOAD"
