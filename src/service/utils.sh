#!/bin/bash

function isset() {
	if [[ -z "$2" ]]; then
    	echo "$1"
    	exit 1
   	fi
}

function callGithub() {
	curl -s --location -u $GH_TOKEN: --header "Accept: application/vnd.github.v3+json" --request $1 "${GITHUB_API_URL}${2}" --data-raw "$3"
}

function callGithubWithoutPrefix() {
	curl -s --location -u $GH_TOKEN: --header "Accept: application/vnd.github.v3+json" --request $1 "$2" --data-raw "$3"
}

function callSonarQube() {
	curl -s -u $SONAR_TOKEN: --request $1 "${SONARQUBE_URL}${2}"
}

function getFileLineCommitHash() {
	line=$2

	git blame -bsl -L${line},$((line+1)) -- "$1" | xargs -n 1 | head -1
}

function getSeverityEmoticon() {
	severityMap=(
		'MAJOR||:warning:'
		'MINOR||:cactus:'
		'BLOCKER||:no_entry:'
		'CRITICAL||:no_entry_sign:'
		'INFO||:information_source:'
	)

	for index in "${severityMap[@]}" ; do
		KEY="${index%%||*}"
        VALUE="${index##*||}"

        if [[ $KEY == $1 ]]; then
        	printf $VALUE
        	break;
       	fi
    done
}

function getPrNumberFromPrUrl() {
	echo "$1" | sed 's/[^0-9]*//g'
}

_jq() {
    printf "${1}" | base64 --decode | jq -r ${2}
}
