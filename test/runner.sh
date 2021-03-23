#!/bin/bash

# Basic integration testing where we don't have a lot of control over the functions already defined.

TEST_DIR="$(dirname "$0")"
__DIR__="$TEST_DIR/../bin"

function assertEquals() {
	if [[ $1 != $2 ]]; then
		echo "[FAILURE] Expected '$2' to be equal to '$1' but was not."
	fi
}

function assertContains() {
	if [[ "$1" != *"$2"* ]]; then
	  echo "[FAILURE] Expected to find '$2' in '$1' but was not."
	fi
}

function assertNotContains() {
	if [[ "$1" == *"$2"* ]]; then
	  echo "[FAILURE] Expected to not find '$2' in '$1' but was not."
	fi
}

# Setup
# This branch will be used to run all tests.
NO_PR_BRANCH=testing-ccls-826
PR_BRANCH=CCLS-826/sonarqube-pr-functionality-running-when-pr-not-open

# Tests to run through.
echo 'Running tests test_github_delete_summary_from_pr' && . $TEST_DIR/bin/test_github_delete_summary_from_pr.sh && echo 'OK'
echo 'Running tests test_github_post_sonarqube_summary' && . $TEST_DIR/bin/test_github_post_sonarqube_summary.sh && echo 'OK'
echo 'Running tests test_sonarqube_relay_feedback_on_pr' && . $TEST_DIR/bin/test_sonarqube_relay_feedback_on_pr.sh && echo 'OK'
echo 'Running tests test_sonarqube_status.sh' && . $TEST_DIR/bin/test_sonarqube_status.sh && echo 'OK'
