## Introduction
Here is a quick documentation about how to deploy this meetup demo EKS Cluster with networks.

This demo was done only to present you how we can deploy EKS Cluster on AWS  and creating a federation beetween EKS and GKE on GCP (we will let you create the GCP code to deploy the cluster :-) )

All deployment here, are pubicly accessible, so this is not secure to use it for any environment except for lab / trainning purpose.


You also need to build an AMI using the official EKS AMI repository here https://github.com/awslabs/amazon-eks-ami
You will have to use packer, all is explained on the documentation or the repository.


All information needed about EKS can be found here : https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html

cluster deployment : https://docs.aws.amazon.com/eks/latest/userguide/create-cluster.html

worker deployment : https://docs.aws.amazon.com/eks/latest/userguide/worker.html

troubleshooting : https://docs.aws.amazon.com/eks/latest/userguide/troubleshooting.html


## AWS CLI configuration
You will need to configure you AWS credential to use terraform
here is the documentation. https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html


## Deploying network
go to AWS/network

terraform init

terraform plan -var-file=../meetup_vars.tfvars

terraform apply -var-file=../meetup_vars.tfvars


## Deploying K8S
go to AWS/k8s

terraform init

terraform plan -var-file=../meetup_vars.tfvars

terraform apply -var-file=../meetup_vars.tfvars

After deployment you will have to apply a K8S configmap for aws iam authenticator purpose

https://docs.aws.amazon.com/eks/latest/userguide/launch-workers.html

when it's done you can kubectl get nodes (you will need to create a kubeconfig file before)

## Destroying k8s 
go to AWS/k8s

terraform destroy -var-file=../meetup_vars.tfvars

## Destroying networks 
go to AWS/network

terraform destroy -var-file=../meetup_vars.tfvars
