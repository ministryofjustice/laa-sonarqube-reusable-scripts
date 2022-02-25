#!/bin/bash

function getPrFilesOnly() {
    echo $(getPrFilesSummary ${1} | jq -r '.[].filename')
}

function getPrFilesSummary() {
    callGithub GET "/repos/$REPOSITORY_ORGANISATION/$REPOSITORY_NAME/pulls/${1}/files"
}
