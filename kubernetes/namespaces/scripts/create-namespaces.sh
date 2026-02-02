#!/bin/sh
### All scripts in this project should be ran from project root directory ###
set -e
echo "### --- Start --- ###"
set -x

### --- Start --- ###



kubectl apply -f kubernetes/namespaces/configs/

kubectl get ns

kubectl get pods -A



### --- END --- ###

set +x
echo "### --- END --- ###"