##########################################
# Gatekeeper                             #
# Open Policy Agent (OPA) For Kubernetes #
# https://youtu.be/14lGc7xMAe4           #
##########################################

# Referenced videos:
# - How to run local multi-node Kubernetes clusters using kind: https://youtu.be/C0v5gJSWuSo
# - Kustomize - How to Simplify Kubernetes Configuration Management: https://youtu.be/Twtbg6LFnAg

#########
# Setup #
#########

git clone https://github.com/vfarcic/opa-gatekeeper-demo.git

cd opa-gatekeeper-demo

export KUBECONFIG=$PWD/kubeconfig.yaml

# Feel free to use any other Kubernetes cluster
# You might want to watch https://youtu.be/C0v5gJSWuSo if you are not familiar with kind
kind create cluster

kubectl apply \
    --filename https://raw.githubusercontent.com/open-policy-agent/gatekeeper/release-3.3/deploy/gatekeeper.yaml

# You might want to watch https://youtu.be/Twtbg6LFnAg if you are not familiar with Kustomize
kustomize build \
    github.com/open-policy-agent/gatekeeper-library/library \
    | kubectl apply --filename -

kubectl apply --filename opa

# Repeat the previous command if the output states that it has `no matches for kind`.

cp app/orig.yaml app/app.yaml

kubectl create namespace production

#####################
# Disallow NodePort #
#####################

cat app/app.yaml

kubectl apply --filename app/app.yaml

cat opa/block-node-port.yaml

echo https://github.com/open-policy-agent/gatekeeper-library

# Open it

# Open `app/app.yaml` and change Service `spec.type` to `ClusterIP`

kubectl apply --filename app/app.yaml

###########################
# Require resource limits #
###########################

kubectl get pods

kubectl get deployments

kubectl describe deployment \
    devops-toolkit

kubectl get replicasets

# Replace `[...]` with the ReplicaSet name
kubectl describe replicaset

# Open `app/app.yaml` and add `spec.template.spec.containers[].resources` with limits set to `10000m` CPU and `10Gi` memory.

kubectl apply --filename app/app.yaml

kubectl get replicasets

# Replace `[...]` with the ReplicaSet name
kubectl describe replicaset [...]

cat opa/container-must-have-limits.yaml

# Open `app/app.yaml` and change `spec.template.spec.containers[].resources.limits` to `500m` CPU and `512Mi` memory.

kubectl apply --filename app/app.yaml

kubectl get pods

#######################
# Disallow latest tag #
#######################

kubectl --namespace production apply \
    --filename app/app.yaml

kubectl --namespace production get pods

kubectl --namespace production \
    get replicasets

# Replace `[...]` with the ReplicaSet name
kubectl --namespace production \
    describe replicaset

cat opa/image-not-latest.yaml

# Open `app/app.yaml` and change `spec.template.spec.containers[].image` to `vfarcic/devops-toolkit-series:2.7.0`

kubectl --namespace production apply \
    --filename app/app.yaml

kubectl --namespace production get pods

###########
# Destroy #
###########

kind delete cluster
