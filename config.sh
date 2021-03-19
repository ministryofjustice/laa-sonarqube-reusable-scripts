#!/bin/bash

## These scripts are expected to be used during CI. This file serves as a reminder of which global variables are expected to be available for the scripts to run as expected.
## To override any variables, add the necessary statement and run the config again i.e "export SONAR_TOKEN=... >> config.sh && ./config.sh"
## All variables can be overridden by passing them explicitly to the script or setting them in the environment.

# No trailing slash.
GITHUB_API_URL=${GITHUB_API_URL:=https://api.github.com}

# No trailing slash.
SONARQUBE_URL=${SONARQUBE_URL:=""}

# Identify the organisation of the repository.
REPOSITORY_ORGANISATION=${REPOSITORY_ORGANISATION:=""}

# The name of the repository.
REPOSITORY_NAME=${REPOSITORY_NAME:=""}

# The path to the target repository on shell. When running, some commands may require running sub-commands within the target repository.
REPOSITORY_PATH=${REPOSITORY_PATH:=""}

# Authenticates requests with Github
GH_TOKEN=${GH_TOKEN:=""}

# Authenticates requests with SonarQube
SONAR_TOKEN=${SONAR_TOKEN:=""}

# Identifies the project in SonarQube, also known as the project-key.
SONARQUBE_COMPONENT_ID=${SONARQUBE_COMPONENT_ID:=""}
