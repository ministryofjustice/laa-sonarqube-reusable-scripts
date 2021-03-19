#!/bin/bash

isset "GH_TOKEN must be set." $GH_TOKEN
isset "SONAR_TOKEN must be set." $SONAR_TOKEN
isset "SONARQUBE_URL must be set." $SONARQUBE_URL
isset "GITHUB_API_URL must be set." $GITHUB_API_URL
isset "REPOSITORY_ORGANISATION must be set." $REPOSITORY_ORGANISATION
isset "REPOSITORY_NAME must be set." $REPOSITORY_NAME
isset "SONARQUBE_COMPONENT_ID must be set." $SONARQUBE_COMPONENT_ID
