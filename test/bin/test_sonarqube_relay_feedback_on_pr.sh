#!/bin/bash

function noPr() {
	RESULT=$(BRANCH=$NO_PR_BRANCH $__DIR__/sonarqube_relay_feedback_on_pr.sh)
	EXIT_CODE=$?

	assertContains "$RESULT" "PR for branch '$NO_PR_BRANCH' not found"
	assertNotContains "$RESULT" "Retrieving existing pull request comments"
	assertNotContains "$RESULT" "Retrieving SonarQube feedback for issues raised"
	assertNotContains "$RESULT" "No issues found."
	assertEquals $EXIT_CODE 1
}

function hasPrAndNoIssuesOnSonarQube() {
	RESULT=$(BRANCH=$PR_BRANCH $__DIR__/sonarqube_relay_feedback_on_pr.sh)
	EXIT_CODE=$?

	assertContains "$RESULT" "Retrieving existing pull request comments"
	assertContains "$RESULT" "Retrieving SonarQube feedback for issues raised"
	assertContains "$RESULT" "No issues found."
	assertNotContains "$RESULT" "PR for branch '$NO_PR_BRANCH' not found"
	assertEquals $EXIT_CODE 0
}

noPr
hasPrAndNoIssuesOnSonarQube
