# Kubernetes: Learning & Discovery

This markdown docs captures my learning of kubernetes and discovery of what it is and how it works. The contents are written in first-person and explained via my understanding on the ideas/mechanics.


## The Big Picture - What Is Kubernetes

The official <a href="https://kubernetes.io">kubernetes.io</a> defines **kubernetes** as:
> Kubernetes, also known as K8s, is an open source system for automating deployment, scaling, and management of containerized applications.

#### My Thoughts
Basically, it's a **Specification**.

A specification is like a blueprint: it outlines the requirements, criteria, etc for something, somewhat like a `class` in object-oriented programming. 

ECMAScript is an example - it's a specification for a scripting language.

The *Specification* sets the standards for an ***Implementation*** -  an instance of the specification. JavaScript *implements* ECMAScript, just like ActionScript, JScript, etc.

There's an implication to this: 

Kubernetes itself isn't something you directly *download/install*; you find/use an implementation of Kubernetes. This would explain the various tools that exists for running Kubernetes - AWS EKS (Elastic Kubernetes Service), Microsoft AKS (Azure Kubernetes Service), GKE (Google Kubernetes Engine), Kind (Kubernetes in Docker), Minikube (local development), etc. They all technically work the same at the foundational level because they all share the same Kubernetes specification.

So it's key to understand/see Kubernetes as a methodology rather than some specific library/framework.


## The Core Concepts - How Does Kubernetes Work

Kubernetes consists of 2 main aspects: **Control Plane** and **Worker Nodes**.

As often described, the control plane is the "brain" of the cluster - it consists of a few core components and manages the worker nodes in the cluster.

The worker nodes are machines (bare metal or Virtual Machine) where a `pod` or `pods` run. A **Pod** is the smallest deployable unit in Kubernetes - it runs 1 or more containers.

A Pod is basically like running a `docker compose` project where there could be `n` services defined.

To manage the cluster, Kubernetes takes a **declarative** approach - you declare the state of your cluster; Kubernetes then does a routine check to evaluate the actual state compared to the desired state, then works to reconcile.

#### My Thoughts

It's a classic example of, and technique/paradigm for dealing with, **distributed systems**. In distributed systems, where various nodes/computers have to work and coordinates together, there is typically a master node that delegates/instructs worker nodes - the worker nodes communicates its status back to the master node (usually via some agent on the worker node), where data is consolidated/aggregated, etc. The control plane is basically delegating container processes to worker nodes and monitors their status - pretty ingenious.

In the case of Kubernetes, the worker nodes have an agent called `Kubelet`. This agent communicates back to the control plane the pods/containers' health and status.

### Important Note:

Kubernetes does **NOT** provision Hardware. Natively, Kubernetes only orchestrates workloads on *existing* hardware/VMs. There are tools and extensions to managing (adding/removing) the hardware for Kubernetes, like **Cluster Autoscaler** or **Karpenter** that helps with this. Also, some implementations of Kubernetes, especially cloud providers, will add extended capabilities for handling this for you. But, at it's core, Kubernetes does not provision hardware, just orchestrates software/containers.


## Getting Started - Things to understand

To get started, locally, you first need to find an implementation of Kubernetes to use. Popular options are kind (Kubernetes in Docker) and Minikube; i chose kind. You typically need/will use the cli tool `kubectl` (kubernetes control) for interacting with your kubernetes implementation locally.

I installed <a href="https://kind.sigs.k8s.io">Kind</a> via homebrew.

Next, i created a kubernetes cluster. With kind, you can use this to create a cluster:
```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
  - role: control-plane
    extraPortMappings:
      - containerPort: 30080
        hostPort: 8085
  - role: worker
  - role: worker
```

Save this to a file, then run:
```bash
kind create cluster --name my-cluster --config kind-config.yaml
```

Now there's a running kubernetes cluster. This is easier to see using Docker Desktop.

Next is getting familiar with "declaring" things in your cluster. 

In Kubernetes, you have `kind`s of objects. These are <a href="https://kubernetes.io/docs/concepts/overview/working-with-objects/">constructs/entities</a> for managing the cluster. You have constructs for defining roles, namespaces, services, deployments, services, etc. To see the full set of `kind`s of objects you can declare, run `kubectl api-resources`. The output i got when running:
```
ryanwaite28@Ryans-MacBook-Air kubernetes-demo-1 % kubectl api-resources
NAME                                SHORTNAMES   APIVERSION                        NAMESPACED   KIND
bindings                                         v1                                true         Binding
componentstatuses                   cs           v1                                false        ComponentStatus
configmaps                          cm           v1                                true         ConfigMap
endpoints                           ep           v1                                true         Endpoints
events                              ev           v1                                true         Event
limitranges                         limits       v1                                true         LimitRange
namespaces                          ns           v1                                false        Namespace
nodes                               no           v1                                false        Node
persistentvolumeclaims              pvc          v1                                true         PersistentVolumeClaim
persistentvolumes                   pv           v1                                false        PersistentVolume
pods                                po           v1                                true         Pod
podtemplates                                     v1                                true         PodTemplate
replicationcontrollers              rc           v1                                true         ReplicationController
resourcequotas                      quota        v1                                true         ResourceQuota
secrets                                          v1                                true         Secret
serviceaccounts                     sa           v1                                true         ServiceAccount
services                            svc          v1                                true         Service
mutatingwebhookconfigurations                    admissionregistration.k8s.io/v1   false        MutatingWebhookConfiguration
validatingadmissionpolicies                      admissionregistration.k8s.io/v1   false        ValidatingAdmissionPolicy
validatingadmissionpolicybindings                admissionregistration.k8s.io/v1   false        ValidatingAdmissionPolicyBinding
validatingwebhookconfigurations                  admissionregistration.k8s.io/v1   false        ValidatingWebhookConfiguration
customresourcedefinitions           crd,crds     apiextensions.k8s.io/v1           false        CustomResourceDefinition
apiservices                                      apiregistration.k8s.io/v1         false        APIService
controllerrevisions                              apps/v1                           true         ControllerRevision
daemonsets                          ds           apps/v1                           true         DaemonSet
deployments                         deploy       apps/v1                           true         Deployment
replicasets                         rs           apps/v1                           true         ReplicaSet
statefulsets                        sts          apps/v1                           true         StatefulSet
selfsubjectreviews                               authentication.k8s.io/v1          false        SelfSubjectReview
tokenreviews                                     authentication.k8s.io/v1          false        TokenReview
localsubjectaccessreviews                        authorization.k8s.io/v1           true         LocalSubjectAccessReview
selfsubjectaccessreviews                         authorization.k8s.io/v1           false        SelfSubjectAccessReview
selfsubjectrulesreviews                          authorization.k8s.io/v1           false        SelfSubjectRulesReview
subjectaccessreviews                             authorization.k8s.io/v1           false        SubjectAccessReview
horizontalpodautoscalers            hpa          autoscaling/v2                    true         HorizontalPodAutoscaler
cronjobs                            cj           batch/v1                          true         CronJob
jobs                                             batch/v1                          true         Job
certificatesigningrequests          csr          certificates.k8s.io/v1            false        CertificateSigningRequest
leases                                           coordination.k8s.io/v1            true         Lease
endpointslices                                   discovery.k8s.io/v1               true         EndpointSlice
events                              ev           events.k8s.io/v1                  true         Event
flowschemas                                      flowcontrol.apiserver.k8s.io/v1   false        FlowSchema
prioritylevelconfigurations                      flowcontrol.apiserver.k8s.io/v1   false        PriorityLevelConfiguration
ingressclasses                                   networking.k8s.io/v1              false        IngressClass
ingresses                           ing          networking.k8s.io/v1              true         Ingress
ipaddresses                         ip           networking.k8s.io/v1              false        IPAddress
networkpolicies                     netpol       networking.k8s.io/v1              true         NetworkPolicy
servicecidrs                                     networking.k8s.io/v1              false        ServiceCIDR
runtimeclasses                                   node.k8s.io/v1                    false        RuntimeClass
poddisruptionbudgets                pdb          policy/v1                         true         PodDisruptionBudget
clusterrolebindings                              rbac.authorization.k8s.io/v1      false        ClusterRoleBinding
clusterroles                                     rbac.authorization.k8s.io/v1      false        ClusterRole
rolebindings                                     rbac.authorization.k8s.io/v1      true         RoleBinding
roles                                            rbac.authorization.k8s.io/v1      true         Role
deviceclasses                                    resource.k8s.io/v1                false        DeviceClass
resourceclaims                                   resource.k8s.io/v1                true         ResourceClaim
resourceclaimtemplates                           resource.k8s.io/v1                true         ResourceClaimTemplate
resourceslices                                   resource.k8s.io/v1                false        ResourceSlice
priorityclasses                     pc           scheduling.k8s.io/v1              false        PriorityClass
csidrivers                                       storage.k8s.io/v1                 false        CSIDriver
csinodes                                         storage.k8s.io/v1                 false        CSINode
csistoragecapacities                             storage.k8s.io/v1                 true         CSIStorageCapacity
storageclasses                      sc           storage.k8s.io/v1                 false        StorageClass
volumeattachments                                storage.k8s.io/v1                 false        VolumeAttachment
volumeattributesclasses             vac          storage.k8s.io/v1                 false        VolumeAttributesClass
ryanwaite28@Ryans-MacBook-Air kubernetes-demo-1 % 
```

### How does this work? 

One of the components in the control plane is the **API Server** - ir is used as an entry to the kubernetes cluster. And as with any/every API, there should be Openapi/Swagger docs that describes how to use it - <a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.35/">https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.35/</a> (make sure to use the version that matches your implementation of kubernetes)

So, these `kind`s are basically payloads to the API server.

The yaml files you create for these declarations are in yaml format by way of convention. Another reason for the declarations into files is for the sake of `GitOps`, a technique where version control is used to maintain the state and history of the kubernetes cluster. Running one-off commands via cli can be lost; keeping a history of state changes is better for auditing, managing, etc.

### Basics

At a foundational level, you are going to need the following "entities"/declarations:

* Namespaces= - 
* Service Account
* Role
* RoleBinding
* Service
* Deployment
* Pod
* Ingress

