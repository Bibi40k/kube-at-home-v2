#!/usr/bin/env bash

: '
GitOps with Flux
Here we will be installing [flux](https://toolkit.fluxcd.io/) after some quick bootstrap steps.

1. Verify Flux can be installed

```sh
flux --kubeconfig=./provision/kubeconfig check --pre
# ► checking prerequisites
# ✔ kubectl 1.21.5 >=1.18.0-0
# ✔ Kubernetes 1.21.5+k3s1 >=1.16.0-0
# ✔ prerequisites checks passed
```

2. Pre-create the `flux-system` namespace

```sh
kubectl --kubeconfig=./provision/kubeconfig create namespace flux-system --dry-run=client -o yaml | kubectl --kubeconfig=./provision/kubeconfig apply -f -
```

3. Add the Age key in-order for Flux to decrypt SOPS secrets

```sh
cat ~/.config/sops/age/keys.txt |
    kubectl --kubeconfig=./provision/kubeconfig \
    -n flux-system create secret generic sops-age \
    --from-file=age.agekey=/dev/stdin
```

Variables defined in `./cluster/base/cluster-secrets.sops.yaml` and `./cluster/base/cluster-settings.sops.yaml` will be usable anywhere in your YAML manifests under `./cluster`

4. **Verify** all the above files are **encrypted** with SOPS
5. If you verified all the secrets are encrypted, you can delete the `tmpl` directory now
6.  Push you changes to git

```sh
git add -A
git commit -m "initial commit"
git push
```

7. Install Flux

Due to race conditions with the Flux CRDs you will have to run the below command twice. There should be no errors on this second run.

```sh
kubectl --kubeconfig=./provision/kubeconfig apply --kustomize=./cluster/base/flux-system
# namespace/flux-system configured
# customresourcedefinition.apiextensions.k8s.io/alerts.notification.toolkit.fluxcd.io created
# ...
# unable to recognize "./cluster/base/flux-system": no matches for kind "Kustomization" in version "kustomize.toolkit.fluxcd.io/v1beta1"
# unable to recognize "./cluster/base/flux-system": no matches for kind "GitRepository" in version "source.toolkit.fluxcd.io/v1beta1"
# unable to recognize "./cluster/base/flux-system": no matches for kind "HelmRepository" in version "source.toolkit.fluxcd.io/v1beta1"
# unable to recognize "./cluster/base/flux-system": no matches for kind "HelmRepository" in version "source.toolkit.fluxcd.io/v1beta1"
# unable to recognize "./cluster/base/flux-system": no matches for kind "HelmRepository" in version "source.toolkit.fluxcd.io/v1beta1"
# unable to recognize "./cluster/base/flux-system": no matches for kind "HelmRepository" in version "source.toolkit.fluxcd.io/v1beta1"
```

8. Verify Flux components are running in the cluster

```sh
kubectl --kubeconfig=./provision/kubeconfig get pods -n flux-system
# NAME                                       READY   STATUS    RESTARTS   AGE
# helm-controller-5bbd94c75-89sb4            1/1     Running   0          1h
# kustomize-controller-7b67b6b77d-nqc67      1/1     Running   0          1h
# notification-controller-7c46575844-k4bvr   1/1     Running   0          1h
# source-controller-7d6875bcb4-zqw9f         1/1     Running   0          1h
```

**Congratulations** you have a Kubernetes cluster managed by Flux, your Git repository is driving the state of your cluster.
'

printf "\n * Verify Flux can be installed\n"
flux --kubeconfig=./provision/kubeconfig check --pre

printf "\n * Pre-create the flux-system namespace\n"
kubectl --kubeconfig=./provision/kubeconfig \
    create namespace flux-system --dry-run=client -o yaml | \
    kubectl --kubeconfig=./provision/kubeconfig apply -f -

printf "\n * Add the Age key in-order for Flux to decrypt SOPS secrets\n"
cat ~/.config/sops/age/keys.txt |
    kubectl --kubeconfig=./provision/kubeconfig \
    -n flux-system create secret generic sops-age \
    --from-file=age.agekey=/dev/stdin

printf "\n * Verify cluster secrets defined in *.sops.yaml\n"
echo ./cluster/base/cluster-secrets.sops.yaml
echo ./cluster/base/cluster-settings.sops.yaml

printf "\n * Push you changes to git\n"
git add -A
git commit -m "updates"
git push

printf "\n * Install Flux\n"
kubectl --kubeconfig=./provision/kubeconfig apply --kustomize=./cluster/base/flux-system
printf "\n * Install Flux... this needs to be run twice\n"
kubectl --kubeconfig=./provision/kubeconfig apply --kustomize=./cluster/base/flux-system

printf "\n * Verify Flux components are running in the cluster\n"
kubectl --kubeconfig=./provision/kubeconfig get pods -n flux-system

printf "\n * Flux installed\n"

# shellcheck disable=SC1091
source "${PROJECT_DIR}./scripts/go_to_next_step.inc"
go_to_next_step "6"