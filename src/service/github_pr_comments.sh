#!/bin/bash

function getPrComments() {
	callGithub GET "/repos/$REPOSITORY_ORGANISATION/$REPOSITORY_NAME/issues/${1}/comments"
}

function getPrDiffComments() {
	callGithub GET "/repos/$REPOSITORY_ORGANISATION/$REPOSITORY_NAME/pulls/${1}/comments"
}
