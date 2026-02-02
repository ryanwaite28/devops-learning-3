#!/bin/sh
### All scripts in this project should be ran from project root directory ###
set -e
set -x
echo "### --- Start --- ###"

### --- Start --- ###



# get kuubernetes url
kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}' # cluster URL; expecting 'https://127.0.0.1:52417'
SECRET_NAME=$(kubectl -n ci get sa jenkins-ci -o jsonpath='{.secrets[0].name}')
echo "Service Account Secret Name: $SECRET_NAME"
kubectl -n ci get secret $kubectl -o jsonpath='{.data.token}' | base64 --decode



### --- END --- ###

echo "### --- END --- ###"