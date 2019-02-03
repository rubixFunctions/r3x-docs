# Installing RubiX and Knative

The following guide will result in a RubiX Function deployed to a Knative deployment on GKE

## Before you begin

Knative requires a Kubernetes cluster v1.11 or newer. `kubectl` v1.10 is also
required. This guide walks you through creating a cluster with the correct
specifications for Knative on Google Cloud Platform (GCP).

This guide assumes you are using `bash` in a Mac or Linux environment; some
commands will need to be adjusted for use in a Windows environment.

### Installing the Google Cloud SDK and `kubectl`

1. If you already have `gcloud` installed with `kubectl` version 1.10 or newer,
   you can skip these steps.

   > Tip: To check which version of `kubectl` you have installed, enter:

   ```
   kubectl version
   ```

1. Download and install the `gcloud` command line tool:
   https://cloud.google.com/sdk/install

1. Install the `kubectl` component:
   ```
   gcloud components install kubectl
   ```
1. Authorize `gcloud`:
   ```
   gcloud auth login
   ```

### Setting environment variables

To simplify the command lines for this walkthrough, we need to define a few
environment variables.

Set `CLUSTER_NAME` and `CLUSTER_ZONE` variables, you can replace `knative` and
`europe-west2-a` with cluster name and zone of your choosing.

The `CLUSTER_NAME` needs to be lowercase and unique among any other Kubernetes
clusters in your GCP project. The zone can be
[any compute zone available on GCP](https://cloud.google.com/compute/docs/regions-zones/#available).
These variables are used later to create a Kubernetes cluster.

```bash
export CLUSTER_NAME=knative
export CLUSTER_ZONE=europe-west2-a
```

### Setting up a Google Cloud Platform project

You need a Google Cloud Platform (GCP) project to create a Google Kubernetes
Engine cluster.

1. Set `PROJECT` environment variable, you can replace `r3x-knative-project` with
   the desired name of your GCP project. If you don't have one, we'll create one
   in the next step.
   ```bash
   export PROJECT=r3x-knative-project
   ```
1. If you don't have a GCP project, create and set it as your `gcloud` default:

   ```bash
   gcloud projects create $PROJECT --set-as-default
   ```

   You also need to
   [enable billing](https://cloud.google.com/billing/docs/how-to/manage-billing-account)
   for your new project.

1. If you already have a GCP project, make sure your project is set as your
   `gcloud` default:

   ```bash
   gcloud config set core/project $PROJECT
   ```

   > Tip: Enter `gcloud config get-value project` to view the ID of your default
   > GCP project.

1. Enable the necessary APIs:
   ```bash
   gcloud services enable \
     cloudapis.googleapis.com \
     container.googleapis.com \
     containerregistry.googleapis.com
   ```

## Creating a Kubernetes cluster

To make sure the cluster is large enough to host all the Knative and Istio
components, the recommended configuration for a cluster is:

- Kubernetes version 1.11 or later
- 4 vCPU nodes (`n1-standard-4`)
- Node autoscaling, up to 10 nodes
- API scopes for `cloud-platform`, `logging-write`, `monitoring-write`, and
  `pubsub` (if those features will be used)

1. Create a Kubernetes cluster on GKE with the required specifications:
   ```bash
   gcloud container clusters create $CLUSTER_NAME \
     --zone=$CLUSTER_ZONE \
     --cluster-version=latest \
     --machine-type=n1-standard-4 \
     --enable-autoscaling --min-nodes=1 --max-nodes=10 \
     --enable-autorepair \
     --scopes=service-control,service-management,compute-rw,storage-ro,cloud-platform,logging-write,monitoring-write,pubsub,datastore \
     --num-nodes=3
   ```
1. Grant cluster-admin permissions to the current user:
   ```bash
   kubectl create clusterrolebinding cluster-admin-binding \
   --clusterrole=cluster-admin \
   --user=$(gcloud config get-value core/account)
   ```

Admin permissions are required to create the necessary
[RBAC rules for Istio](https://istio.io/docs/concepts/security/rbac/).

## Installing Istio

Knative depends on Istio.

1. Install Istio:
   ```bash
   kubectl apply --filename https://github.com/knative/serving/releases/download/v0.3.0/istio-crds.yaml && \
   kubectl apply --filename https://github.com/knative/serving/releases/download/v0.3.0/istio.yaml
   ```
   Note: the resources (CRDs) defined in the `istio-crds.yaml`file are
   also included in the `istio.yaml` file, but they are pulled out so that
   the CRD definitions are created first. If you see an error when creating
   resources about an unknown type, run the second `kubectl apply` command
   again.

1. Label the default namespace with `istio-injection=enabled`:
   ```bash
   kubectl label namespace default istio-injection=enabled
   ```
1. Monitor the Istio components until all of the components show a `STATUS` of
   `Running` or `Completed`:
   ```bash
   kubectl get pods --namespace istio-system
   ```

It will take a few minutes for all the components to be up and running; you can
rerun the command to see the current status.

> Note: Instead of rerunning the command, you can add `--watch` to the above
> command to view the component's status updates in real time. Use CTRL + C to
> exit watch mode.

## Installing Knative

The following commands install all available Knative components as well as the
standard set of observability plugins. To customize your Knative installation,
see [Performing a Custom Knative Installation](Knative-custom-install.md).

1. Run the `kubectl apply` command to install Knative and its dependencies:
    ```bash
    kubectl apply --filename https://github.com/knative/serving/releases/download/v0.3.0/serving.yaml \
    --filename https://github.com/knative/build/releases/download/v0.3.0/release.yaml \
    --filename https://github.com/knative/eventing/releases/download/v0.3.0/release.yaml \
    --filename https://github.com/knative/eventing-sources/releases/download/v0.3.0/release.yaml \
    --filename https://github.com/knative/serving/releases/download/v0.3.0/monitoring.yaml
    ```
1. Monitor the Knative components until all of the components show a
   `STATUS` of `Running`:
    ```bash
    kubectl get pods --namespace knative-serving
    kubectl get pods --namespace knative-build
    kubectl get pods --namespace knative-eventing
    kubectl get pods --namespace knative-sources
    kubectl get pods --namespace knative-monitoring
    ```

# Installing RubiX CLI
## Prerequisite
The CLI requires the following :
- GoLang
- Git

## Build Steps
Clone project
```
$ mkdir $GOPATH/src/github.com/rubixFunctions
$ cd $GOPATH/src/github.com/rubixFunctions
$ git clone git@github.com:rubixFunctions/r3x-cli.git
$ cd r3x-cli
$ go build
```
After building the project, add the binary `r3x-cli` to $PATH

### Bootstrap a Function as a Container
```
$ r3x init hello-function --type js 
```

### Create a Function as a Container Image
The create function image locally:
```
$ cd <<function dir>>
$ r3x create -p -n <<Repo Name or Org>>
```
## Building and deploying the sample

Once you have initialized and created the Function as a Container you're ready to deploy the app.


1. After the build has completed and the container is pushed to docker hub, you
   can deploy the app into your cluster. Ensure that the container image value
   in `service.yaml` matches the container you built in the previous step. Apply
   the configuration using `kubectl`:

   ```shell
   kubectl apply --filename service.yaml
   ```

1. Now that your service is created, Knative will perform the following steps:

   - Create a new immutable revision for this version of the app.
   - Network programming to create a route, ingress, service, and load balance
     for your app.
   - Automatically scale your pods up and down (including to zero active pods).

1. To find the IP address for your service, use these commands to get the
   ingress IP for your cluster. If your cluster is new, it may take sometime for
   the service to get asssigned an external IP address.

   ```shell
   # In Knative 0.2.x and prior versions, the `knative-ingressgateway` service was used instead of `istio-ingressgateway`.
   INGRESSGATEWAY=knative-ingressgateway

   # The use of `knative-ingressgateway` is deprecated in Knative v0.3.x.
   # Use `istio-ingressgateway` instead, since `knative-ingressgateway`
   # will be removed in Knative v0.4.
   if kubectl get configmap config-istio -n knative-serving &> /dev/null; then
       INGRESSGATEWAY=istio-ingressgateway
   fi

   kubectl get svc $INGRESSGATEWAY --namespace istio-system

   NAME                     TYPE           CLUSTER-IP     EXTERNAL-IP      PORT(S)                                      AGE
   xxxxxxx-ingressgateway   LoadBalancer   10.23.247.74   35.203.155.229   80:32380/TCP,443:32390/TCP,32400:32400/TCP   2d
   ```

1. To find the URL for your service, use

   ```
   kubectl get ksvc r3x-hello-world  --output=custom-columns=NAME:.metadata.name,DOMAIN:.status.domain
   NAME                DOMAIN
   r3x-hello-world   r3x-hello-world.default.example.com
   ```

1. Now you can make a request to your app to see the result. Replace
   `{IP_ADDRESS}` with the address you see returned in the previous step.

   ```shell
   curl -H "Host: r3x-hello-world.default.example.com" http://{IP_ADDRESS}
   Hello Node.js Sample v1!
   ```

## Cleaning up

To remove the sample app from your cluster, delete the service record:

```shell
kubectl delete --filename service.yaml
```

Running a cluster in Kubernetes Engine costs money, so you might want to delete
the cluster when you're done if you're not using it. Deleting the cluster will
also remove Knative, Istio, and any apps you've deployed.

To delete the cluster, enter the following command:

```bash
gcloud container clusters delete $CLUSTER_NAME --zone $CLUSTER_ZONE
```

---

Except as otherwise noted, the content of this page is licensed under the
[Creative Commons Attribution 4.0 License](https://creativecommons.org/licenses/by/4.0/),
and code samples are licensed under the
[Apache 2.0 License](https://www.apache.org/licenses/LICENSE-2.0).