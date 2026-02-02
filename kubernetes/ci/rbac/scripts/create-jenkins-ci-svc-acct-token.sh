#!/bin/sh
### All scripts in this project should be ran from project root directory ###
set -e
set -x
echo "### --- Start --- ###"

### --- Start --- ###



SERVICE_ACCOUNT_TOKEN=$(kubectl -n ci create token jenkins-ci)
echo "Jenkins CI Service Account Token: $SERVICE_ACCOUNT_TOKEN"



### --- END --- ###

echo "### --- END --- ###"