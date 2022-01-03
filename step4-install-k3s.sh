#!/usr/bin/env bash

: '
Installing k3s with Ansible
Here we will be running a Ansible Playbook to install [k3s](https://k3s.io/) with [this](https://galaxy.ansible.com/xanmanning/k3s) wonderful k3s Ansible galaxy role. After completion, Ansible will drop a `kubeconfig` in `./provision/kubeconfig` for use with interacting with your cluster with `kubectl`.

1. Verify Ansible can view your config by running `task ansible:list`
2. Verify Ansible can ping your nodes by running `task ansible:adhoc:ping`
3. Run the k3s install playbook by running `task ansible:playbook:k3s-install`
4. If everything goes as planned you should see Ansible running the k3s install Playbook against your nodes.
5. Verify the nodes are online

```sh
kubectl --kubeconfig=./provision/kubeconfig get nodes
# NAME           STATUS   ROLES                       AGE     VERSION
# k8s-0          Ready    control-plane,master      4d20h   v1.21.5+k3s1
# k8s-1          Ready    worker                    4d20h   v1.21.5+k3s1
```
'

printf "\n * Installing k3s with Ansible\n"

printf " * Verify Ansible can view your config\n\n"
task ansible:list

printf " * Verify Ansible can ping your nodes\n\n"
task ansible:adhoc:ping

printf " * Running the k3s-install playbook\n\n"
task ansible:playbook:k3s-install

printf " * Verifying the nodes are online\n\n"
kubectl --kubeconfig=./provision/kubeconfig get nodes

printf "\n * k3s install completed\n"

# shellcheck disable=SC1091
source "${PROJECT_DIR}./scripts/go_to_next_step.inc"
go_to_next_step "5"