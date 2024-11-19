#!/bin/bash

export AWS_PROFILE="innovaplay-staging";
EKS_CLUSTER_NAME="inpl-staging-cluster1"
EKS_CLUSTER_WITH_USER_URL="eks-cli-user@inpl-staging-cluster1.eu-west-1.eksctl.io"


# Check kubectl is installed:
kubectl version

# Check aws is installed:
aws --version

# Check helm is installed:
helm version

# Install Metrics Server:
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

# Install ArgoCD
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml


# Create K8 Secret for AWS access keys that will be consumed by pods while setting env
kubectl apply -f ./secret-aws-ssm-credentials.yaml


# helm repo add eks https://aws.github.io/eks-charts
# helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
# -n kube-system \
# --set clusterName=$EKS_CLUSTER_WITH_USER_URL \
# --set serviceAccount.create=true \
# --set enableShield=false


# # configure EKS to get secrets from Parameter Store

# ### kubectl get serviceaccount secrets-store-csi-driver -n kube-system

# kubectl create serviceaccount secrets-store-csi-driver -n kube-system

# ## https://blog.spikeseed.cloud/handling-aws-secrets-and-parameters-on-eks/#retrieving-secrets-and-parameters
# ### https://secrets-store-csi-driver.sigs.k8s.io/getting-started/installation.html
# kubectl apply -f ./secrets-store-csi-driver-role.yaml
# kubectl apply -f ./secrets-store-csi-driver-rolebinding.yaml

# helm repo add secrets-store-csi-driver https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts
# helm install -n kube-system csi-secrets-store secrets-store-csi-driver/secrets-store-csi-driver --set syncSecret.enabled=true

# helm repo add aws-secrets-manager https://aws.github.io/secrets-store-csi-driver-provider-aws
# helm install -n kube-system secrets-provider-aws aws-secrets-manager/secrets-store-csi-driver-provider-aws

# aws iam create-policy --policy-name EksSSMParameterAccessPolicy --policy-document ./ssm-access-policy.json

# ## Step 3: Create an IAM Role with IRSA for the Service Account
# ## Use eksctl to create a Kubernetes service account with the IAM role attached.

# eksctl utils associate-iam-oidc-provider --cluster $EKS_CLUSTER_NAME --approve

# eksctl create iamserviceaccount \
#   --name csi-parameter-store-sa \
#   --namespace default \
#   --cluster $EKS_CLUSTER_NAME \
#   --attach-policy-arn arn:aws:iam::975050051202:policy/EksSSMParameterAccessPolicy \
#   --approve \
#   --override-existing-serviceaccounts