## Introduction

This repository is meant to hold SonarQube scripts to facilitate developer workflow in CI. When using SonarQube's community edition, there are several limitations to a good CI workflow. Added features such as pull `request decoration` can either be accessed through plugins or developer edition +. These scripts serve as an interim solution to bridge the gap in that functionality.

### Dependencies:
- JQ, sed, base64, git and curl libraries for shell.
- Running instance of SonarQube with auth token.
- Github access token.

### Installation:

To avoid being affected by changes introduced in the main branch, clone a particular tag rather than a branch.

```
git clone --depth 1 --branch <tag_name> <this_repo_url>
```

Create config from template file

```
cp config.sh.template config.sh
```

The config.sh file houses all global variables used by the script. These can be overridden by passing in the explicit variables per command

```
GH_TOKEN="the-github-token" PULL_REQUEST_URL="https://the-url" ./bin/github_delete_summary_from_pr.sh
```

or by overriding them in the following manner.

```
echo "GH_TOKEN='$GH_TOKEN'"  >> ./config.sh
```

Once globals are set they don't need to be passed in on runtime. On CI, the template would be:

```
echo "GITHUB_API_URL=''" >> ./config.sh
echo "GH_TOKEN=''" >> ./config.sh

echo "REPOSITORY_PATH=''" >> ./config.sh
echo "REPOSITORY_NAME=''" >> ./config.sh
echo "REPOSITORY_ORGANISATION=''" >> ./config.sh

echo "SONARQUBE_URL=''" >> ./config.sh
echo "SONAR_TOKEN=''" >> ./config.sh
echo "SONARQUBE_COMPONENT_ID=''" >> ./config.sh
```

### Running commands:

Commands are located in the bin folder. Running a command

```
PULL_REQUEST_URL="https://the-url" ./bin/github_delete_summary_from_pr.sh
```

For example, When SonarQube analysis is done

```
# If implementation is not based on webhook, account for propagation delay.
wait 15

# Decorate/Post a summary of the stats from SonarQube on the pull request.
BRANCH=$CIRCLE_BRANCH PULL_REQUEST_URL=$CIRCLE_PULL_REQUEST ./laa-sonarqube-reusable-scripts/bin/github_post_sonarqube_summary.sh

# Decorate/Post individual issues found by SonarQube on the pull request.
PULL_REQUEST_URL=$CIRCLE_PULL_REQUEST ./laa-sonarqube-reusable-scripts/bin/sonarqube_relay_feedback_on_pr.sh

# If SonarQube failed, exit with non-zero exit code.
./laa-sonarqube-reusable-scripts/bin/sonarqube_status.sh
```

### In CI

SonarQube allows users to register webhooks to respond to events such as post analysis actions. For such an implementation one needs an active resource listening for those webhooks. In the absence of such facility, these scripts can be used within the CI pipeline to achieve certain functionality.

### Development and changes

Any changes introduced should be tagged using SemVer versioning strategy.

Integration tests are fully end to end. In order to run these tests you'll need to have:
- A target repository
- A branch without any associated PRs open.
- A branch with one or many associated PRs open.

Once you have the above, open the test/runner.sh file to set project up. 
