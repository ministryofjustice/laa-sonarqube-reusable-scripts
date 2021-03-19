#!/bin/bash

# This scirpt depends on the jq and sed command line tool(s) to be installed and the quality gates metrics to be passed in as the first parameter.

metricsMap=(
    'ncloc::Lines of code'
    'coverage::Test Coverage'
    'new_coverage::Test Coverage'
    'bugs::Bugs'
    'vulnerabilities::Vulnerabilities'
    'code_smells::Code Smells'
    'violations::Violations'
    'security_rating::Security Rating'
    'duplicated_blocks::Duplicated blocks'
    'complexity::Complexity'
    'new_bugs::Bugs'
    'new_vulnerabilities::Vulnerabilities'
    'new_violations::Violations'
    'new_code_smells::Code Smells'
    'new_technical_debt::Techincal Debt'
)

_jq() {
    printf "${row}" | base64 --decode | jq -r ${1}
}

printMetrics() {
    for row in $(printf "${1}" | jq -r '.[] | @base64'); do
        METRIC=$(_jq '.metric')

        for index in "${metricsMap[@]}" ; do
            KEY="${index%%::*}"
            VALUE="${index##*::}"

            if [[ $KEY == $METRIC ]]; then
                printf "$VALUE - $(_jq "$2")<br />";
                break;
            fi
        done
    done
}

function quality_gate_metrics() {
    # Quality gate metrics.
    qualityGateResponse=$(callSonarQube GET "/api/qualitygates/project_status?projectKey=$SONARQUBE_COMPONENT_ID")
    SONAR_STATUS=$(printf "$qualityGateResponse" | jq .projectStatus.status | sed "s/\"//g")
    SONAR_MAINTAINABILITY=$(printf "$qualityGateResponse" | jq '.projectStatus.conditions | .[2].status' | sed "s/\"//g")
    SONAR_RELIABIILTY=$(printf "$qualityGateResponse" | jq '.projectStatus.conditions | .[0].status' | sed "s/\"//g")
    SONAR_SECURITY=$(printf "$qualityGateResponse" | jq '.projectStatus.conditions | .[1].status' | sed "s/\"//g")

    if [[ $SONAR_STATUS != 'OK' ]]; then
        SONAR_STATUS=":exclamation: $SONAR_STATUS"
    fi

    printf "<br />Status: $SONAR_STATUS<br />Maintainability: $SONAR_MAINTAINABILITY<br />Reliability: $SONAR_RELIABIILTY<br />Security: $SONAR_SECURITY<br /><br />"
}

function new_code_summary() {
    # New code
    changedMetricsResponse=$(callSonarQube GET "/api/measures/component?component=$SONARQUBE_COMPONENT_ID&metricKeys=new_violations,new_code_smells,new_bugs,new_vulnerabilities,new_technical_debt,new_coverage")
    SONAR_CHANGED_METRICS=$(printf "$changedMetricsResponse" | jq '.component.measures')
    printf ':radioactive: <b>New Code</b><br />'
    printMetrics "${SONAR_CHANGED_METRICS}" '.period.value'
}

function existing_code_summary() {
    # Existing code
    metricsResponse=$(callSonarQube GET "/api/measures/component?component=$SONARQUBE_COMPONENT_ID&metricKeys=coverage,bugs,vulnerabilities,code_smells,ncloc,complexity,violations,duplicated_blocks,complexity,security_rating")
    SONAR_METRICS=$(printf "$metricsResponse" | jq '.component.measures')
    printf '<br />:t-rex: <b>Existing Code</b><br />'
    printMetrics "${SONAR_METRICS}" '.value'
}
