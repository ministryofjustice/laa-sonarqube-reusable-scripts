#!/bin/bash

# Check status of SonarQube.

__DIR__="$(dirname "$0")"

. "$__DIR__/../src/service/utils.sh"
. "$__DIR__/../config.sh"
. "$__DIR__/../src/service/validate_globals.sh"

SONAR_STATUS=$(callSonarQube GET "/api/qualitygates/project_status?projectKey=$SONARQUBE_COMPONENT_ID")
if [[ $(echo $SONAR_STATUS | jq .projectStatus.status | sed "s/\"//g") != 'OK' ]]; then
  echo 'SonarQube quality gate failed.'
  exit 1
fi
