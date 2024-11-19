#!/bin/bash
set -e

export AWS_PROFILE="innovaplay-staging";
EKS_AWS_REGION="eu-west-1"
EKS_CLUSTER_NAME="inpl-staging-cluster1"

# Check kubectl is installed:
kubectl version --client

# Check aws is installed:
aws --version

# Check eksctl is installed:
eksctl version

# Check helm is installed:
helm version

# Create EKS cluster on AWS: [!! Double check the subnet and cluster configs before executing this cmd !!]
eksctl create cluster -f ./eks-cluster-config.yaml

# # Update Kubeconfig file:
aws eks --region $EKS_AWS_REGION update-kubeconfig --name $EKS_CLUSTER_NAME
