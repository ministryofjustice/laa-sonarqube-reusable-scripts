## Introduction

This repository is meant to hold SonarQube scripts to facilitate developer workflow in CI. When using SonarQube's community edition, there are several limitations to a good CI workflow. Added features such as pull `request decoration` can either be accessed through plugins or developer edition +. These scripts serve as an interim solution to bridge the gap in that functionality.

### Dependencies:
- JQ library for shell.
- Running instance of SonarQube with auth token.
- Github access token.

### Installation:

The config.sh file houses all global variables used by the script. These can be overridden by passing in the explicit variables per command

```
GH_TOKEN="the-github-token" BRANCH="xyz" PULL_REQUEST_URL="https://the-url" ./src/command/github_delete_summary_from_pr.sh
```

or by overriding them in the following manner.

```
GH_TOKEN=$GH_TOKEN  >> ./config.sh
```

Once globals are set they don't need to be passed in on runtime. On CI, the template would be:

```
GITHUB_API_URL="" >> ./config.sh
GH_TOKEN="" >> ./config.sh

REPOSITORY_PATH="" >> ./config.sh
REPOSITORY_NAME="" >> ./config.sh
REPOSITORY_ORGANISATION="" >> ./config.sh

SONARQUBE_URL="" >> ./config.sh
SONAR_TOKEN="" >> ./config.sh
SONARQUBE_COMPONENT_ID="" >> ./config.sh
```

### Running commands:

Then run the command

```
BRANCH="xyz" PULL_REQUEST_URL="https://the-url" ./src/command/github_delete_summary_from_pr.sh
```

### In CI

SonarQube allows users to register webhooks to respond to events such as post analysis actions. For such an implementation one needs an active resource listening for those webhooks. In the absence of such facility, these scripts can be used within the CI pipeline to achieve certain functionality.
