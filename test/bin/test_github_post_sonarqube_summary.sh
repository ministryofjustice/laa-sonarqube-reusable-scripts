#!/bin/bash

function noPr() {
	RESULT=$(BRANCH=$NO_PR_BRANCH $__DIR__/github_post_sonarqube_summary.sh)
	EXIT_CODE=$?

	assertContains "$RESULT" "PR for branch '$NO_PR_BRANCH' not found"
	assertNotContains "$RESULT" "Deleting existing SonarQube summary if exists."
	assertNotContains "$RESULT" "Send updated summary"
	assertEquals $EXIT_CODE 1
}

function hasPr() {
	RESULT=$(BRANCH=$PR_BRANCH $__DIR__/github_post_sonarqube_summary.sh)
	EXIT_CODE=$?

	assertNotContains "$RESULT" "PR for branch '$NO_PR_BRANCH' not found"
	assertContains "$RESULT" "Deleting existing SonarQube summary if exists."
	assertContains "$RESULT" "Send updated summary"
	assertEquals $EXIT_CODE 0
}

noPr
hasPr
