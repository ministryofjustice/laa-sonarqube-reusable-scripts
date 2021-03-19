## Introduction

This repository is meant to hold SonarQube scripts to facilitate developer workflow in CI. When using SonarQube's community edition, there are several limitations to a good CI workflow. Added features such as pull `request decoration` can either be accessed through plugins or developer edition +. These scripts serve as an interim solution to bridge the gap in that functionality.

### Dependencies:
- JQ library for shell.
- Running instance of SonarQube with auth token.
- Github access token.

### Installation:

Create config from template file

```
cp config.sh.template config.sh
```

The config.sh file houses all global variables used by the script. These can be overridden by passing in the explicit variables per command

```
GH_TOKEN="the-github-token" PULL_REQUEST_URL="https://the-url" ./src/command/github_delete_summary_from_pr.sh
```

or by overriding them in the following manner.

```
echo 'GH_TOKEN=$GH_TOKEN'  >> ./config.sh
```

Once globals are set they don't need to be passed in on runtime. On CI, the template would be:

```
echo 'GITHUB_API_URL=""' >> ./config.sh
echo 'GH_TOKEN=""' >> ./config.sh

echo 'REPOSITORY_PATH=""' >> ./config.sh
echo 'REPOSITORY_NAME=""' >> ./config.sh
echo 'REPOSITORY_ORGANISATION=""' >> ./config.sh

echo 'SONARQUBE_URL=""' >> ./config.sh
echo 'SONAR_TOKEN=""' >> ./config.sh
echo 'SONARQUBE_COMPONENT_ID=""' >> ./config.sh
```

### Running commands:

Then run the command

```
PULL_REQUEST_URL="https://the-url" ./src/command/github_delete_summary_from_pr.sh
```

For example, When SonarQube analysis is done

```
# If implementation is not based on webhook, account for propagation delay.
wait 15

# Decorate/Post a summary of the stats from SonarQube on the pull request.
BRANCH=$CIRCLE_BRANCH PULL_REQUEST_URL=$CIRCLE_PULL_REQUEST ./laa-sonarqube-reusable-scripts/src/command/github_post_sonarqube_summary.sh

# Decorate/Post individual issues found by SonarQube on the pull request.
PULL_REQUEST_URL=$CIRCLE_PULL_REQUEST ./laa-sonarqube-reusable-scripts/src/command/sonarqube_relay_feedback_on_pr.sh

# If SonarQube failed, exit with non-zero exit code.
./laa-sonarqube-reusable-scripts/src/command/sonarqube_status.sh
```

### In CI

SonarQube allows users to register webhooks to respond to events such as post analysis actions. For such an implementation one needs an active resource listening for those webhooks. In the absence of such facility, these scripts can be used within the CI pipeline to achieve certain functionality.
