#!/bin/bash

function RunCommand() {
	RESULT=$(BRANCH=$NO_PR_BRANCH $__DIR__/sonarqube_status.sh)
	EXIT_CODE=$?

	assertEquals "$RESULT" ""
	assertEquals $EXIT_CODE 0
}

RunCommand
