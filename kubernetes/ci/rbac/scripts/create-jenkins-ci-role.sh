#!/bin/sh
### All scripts in this project should be ran from project root directory ###
set -e
set -x
echo "### --- Start --- ###"

### --- Start --- ###



kubectl apply -f kubernetes/ci/rbac/configs/jenkins-ci.rbac.yaml

kubectl auth can-i create pods \
  --as=system:serviceaccount:ci:jenkins-ci \
  -n ci

kubectl auth can-i create pods \
  --as=system:serviceaccount:ci:jenkins-ci \
  -n default



### --- END --- ###

echo "### --- END --- ###"