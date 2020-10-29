# Kubernetes Commands Cheat Sheet

Official: https://kubernetes.io/docs/reference/kubectl/cheatsheet/

``` bash

# Dump pod logs, with label name=myLabel (stdout)
kubectl logs -l name=myLabel -c my-container

# Restart Rollout (and pull container image if imagePullPolicy: Always)
kubectl rollout restart deployment/frontend 

# Auto scale a deployment "foo"
kubectl autoscale deployment foo --cpu-percent=20 --min=1 --max=10 

# List Nodepools
az aks nodepool list --cluster-name MyManagedCluster -g MyResourceGroup -o table

# Add Nodepool
az aks nodepool add -g MyResourceGroup -n nodepool1 --cluster-name MyManagedCluster --node-vm-size=Standard_XX --mode User

# Delete Nodepool
az aks nodepool delete -n OldNodePool --cluster-name MyManagedCluster -g MyResourceGroup

```
