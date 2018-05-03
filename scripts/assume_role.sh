#!/bin/bash -ex
 
#
# Script to assume a role and extract credentials.  Can be used in conjunction any other
# shell script that needs to switch roles.
#
ROLE_ARN=$1
ROLE_SESSION_NAME=${2:-"AssumeRoleSessionName"}
 
if [[ -z $ROLE_ARN} ]] ; then
    echo "Expected Role ARN to be provided".
    exit 1
fi
 
TMP_FILE=/tmp/role.json
 
export AWS_REGION="ap-southeast-2"
aws sts assume-role --role-arn "${ROLE_ARN}" --role-session-name "${ROLE_SESSION_NAME}" > ${TMP_FILE}
AWS_SECRET_ACCESS_KEY=$(exec grep SecretAccessKey ${TMP_FILE} | awk -F: '{print $2}' | awk -F\" '{print $2}')
export AWS_SECRET_ACCESS_KEY
AWS_ACCESS_KEY_ID=$(grep AccessKeyId ${TMP_FILE} | awk -F: '{print $2}' | awk -F\" '{print $2}')
export AWS_ACCESS_KEY_ID
AWS_SECURITY_TOKEN=$(grep SessionToken ${TMP_FILE} | awk -F: '{print $2}' | awk -F\" '{print $2}')
export AWS_SECURITY_TOKEN
