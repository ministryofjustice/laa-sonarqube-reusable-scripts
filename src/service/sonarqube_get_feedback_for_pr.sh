#!/bin/bash

function getSonarQubeLastRunIssuesFeedback() {
	callSonarQube GET "/api/issues/search?componentKeys=$SONARQUBE_COMPONENT_ID&sinceLeakPeriod=true"
}


