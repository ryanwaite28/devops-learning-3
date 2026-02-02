#!/bin/sh
### All scripts in this project should be ran from project root directory ###
set -e
set -x
echo "### --- Start --- ###"

### --- Start --- ###



kind create cluster \
  --name kube-lab \
  --config kubernetes/clusters/kind/configs/kind-cluster.yaml

kubectl cluster-info

kubectl get nodes



### --- END --- ###

echo "### --- END --- ###"