## Introduction 
Here is the documentation needed to deploy the federation between EKS and GCP.

First part is to installation & configuration the required tool for administration.

Here is all official documentation :

https://kubernetes.io/fr/docs/tasks/tools/install-kubectl/

https://github.com/kubernetes-sigs/kubefed

https://github.com/kubernetes-sigs/kubefed/blob/master/docs/userguide.md

https://helm.sh/docs/


## Install kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl

chmod +x ./kubectl

sudo mv ./kubectl /usr/local/bin/kubectl


## Install kubefedctl
wget https://github.com/kubernetes-sigs/kubefed/releases/download/v0.5.0/kubefedctl-0.5.0-linux-amd64.tgz

wget https://github.com/kubernetes-sigs/kubefed/releases/download/v0.5.0/kubefedctl-0.5.0-darwin-amd64.tgz

tar -zxvf kubefedctl-*.tgz

chmod u+x kubefedctl

sudo mv kubefedctl /usr/local/bin/


## get kubectl config file
aws --region eu-west-1 eks update-kubeconfig --name <EKS-Cluster-Name> --profile=<awscli-profile>

gcloud container clusters get-credentials <GKE-Cluster-Name>

Modify the .kube/config file (who contains the 2 cluster definition) in order to set proper context name.

For demo, we put meetup-demo-eks for EKS context and meetup-demo-gke for GCP context.

All the k8s resource file are configured with this context name.

Put the meetup-demo-eks or meetup-demo-gke as default context (as you prefer :-) )


## Install helm v3
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3

chmod 700 get_helm.sh

./get_helm.sh


## start deploy federation AWS EKS OR GKE
helm repo add kubefed-charts https://raw.githubusercontent.com/kubernetes-sigs/kubefed/master/charts

helm --namespace kube-federation-system upgrade -i kubefed kubefed-charts/kubefed --version=0.5.0 --create-namespace

kubefedctl join meetup-demo-eks --cluster-context meetup-demo-eks

kubefedctl join meetup-demo-gke --cluster-context meetup-demo-gke

kubectl -n kube-federation-system get kubefedclusters


## deploy resources on K8S
kubectl apply -f federated-ns.yaml

kubectl apply -f federated-nginx.yaml

kubectl apply -f federated-service.yaml

kubectl apply -f ingress-gke.yaml --context meetup-demo-gke -> you will need to update the yaml file to add a GCP Public IP.
