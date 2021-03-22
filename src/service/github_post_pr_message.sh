#!/bin/bash

# This script is meant to send a message from circle ci to github pull requests. To use:

# Param 1: Github auth token, Param 2: message to send.
function sendPrMessage() {
	BRANCH="$1"
	BODY="$2"

	echo 'Fetching PR URL';
	pr_response=$(callGithub GET "/repos/$REPOSITORY_ORGANISATION/$REPOSITORY_NAME/pulls?head=$REPOSITORY_ORGANISATION:$BRANCH&state=open")
	if [ $(echo $pr_response | jq length) -eq 0 ]; then
	  echo "No PR found to update, response: $pr_response"
	else
	  pr_comment_url=$(echo $pr_response | jq -r ".[]._links.comments.href")
	  JSON='{ "body": "'"$BODY"'" }'
	  echo 'Sending message to PR: '$pr_comment_url
	  callGithubWithoutPrefix POST "$pr_comment_url" "$JSON"
	fi
}

function commentOnDiff() {
	PULL_REQUEST_NUMBER=$3
	COMMIT_ID=$4
	FILE_PATH="$5"
	LINE=$6
	MESSAGE="${7}"
	MESSAGE="${MESSAGE//\"/\\\"}"

	JSON='{ "body": "'"$MESSAGE"'", "path": "'"$FILE_PATH"'", "line": '$LINE', "side": "RIGHT", "commit_id": "'"$COMMIT_ID"'" }'

	echo 'Comment: '$MESSAGE
	echo 'File: '$FILE_PATH':'$LINE

	callGithub POST "/repos/$1/$2/pulls/$PULL_REQUEST_NUMBER/comments" "$JSON"
}

# Param 1 is expected to be sonarqube issues feedback in json.
function commentOnDiffs() {
	PULL_REQUEST_NUMBER=$1

	for row in $(echo "${2}" | jq -r '.[] | @base64'); do
		component=$(_jq "$row" '.component')

		arrIN=(${component//:/ })
		issueKey=$(_jq "$row" '.key')
        LINE=$(_jq "$row" '.line')
        MESSAGE=$(_jq "$row" '.message')"<br /><br /><a href='$SONARQUBE_URL/project/issues?id=$SONARQUBE_COMPONENT_ID&open=$issueKey&sinceLeakPeriod=true'>View details on SonarQube</a>"
        SEVERITY=$(_jq "$row" '.severity')
        FILE_PATH=${arrIN[1]}

        # Needs to be executed in the main source repository. Creates a huge dependency.
        COMMIT_ID=$(cd $REPOSITORY_PATH && getFileLineCommitHash "$FILE_PATH" $LINE)

        if [[ -z $COMMIT_ID ]]; then
        	echo 'UNABLE TO EXTRACT COMMIT ID FOR THE CHANGE FROM REPOSITORY PATH: '$REPOSITORY_PATH
        	exit 1
       	fi

        commentOnDiff $REPOSITORY_ORGANISATION $REPOSITORY_NAME $PULL_REQUEST_NUMBER $COMMIT_ID "$FILE_PATH" $LINE "[SONARQUBE BOT ISSUE]<br /><br />"$(getSeverityEmoticon $SEVERITY)" $MESSAGE"
    done
}
