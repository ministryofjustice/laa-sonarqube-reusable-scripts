#!/bin/bash

function noPr() {
	RESULT=$(BRANCH=$NO_PR_BRANCH $__DIR__/github_delete_summary_from_pr.sh)
	EXIT_CODE=$?

	assertContains "$RESULT" "PR for branch '$NO_PR_BRANCH' not found"
	assertNotContains "$RESULT" "Deleting existing SonarQube summary if exists."
	assertEquals $EXIT_CODE 1
}

function hasPr() {
	RESULT=$(BRANCH=$PR_BRANCH $__DIR__/github_delete_summary_from_pr.sh)
	EXIT_CODE=$?

	assertContains "$RESULT" "Deleting existing SonarQube summary if exists."
	assertNotContains "$RESULT" "PR for branch '$NO_PR_BRANCH' not found"
	assertEquals $EXIT_CODE 0
}

noPr
hasPr
