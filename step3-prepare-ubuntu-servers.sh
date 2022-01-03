#!/usr/bin/env bash

: '
Preparing Ubuntu with Ansible
Here we will be running a Ansible Playbook to prepare Ubuntu for running a Kubernetes cluster.
Nodes are not security hardened by default, you can do this with [dev-sec/ansible-collection-hardening](https://github.com/dev-sec/ansible-collection-hardening) or something similar.

1. Ensure you are able to SSH into you nodes from your workstation with using your private ssh key. This is how Ansible is able to connect to your remote nodes.
2. Install the deps by running `task ansible:deps`
3. Verify Ansible can view your config by running `task ansible:list`
4. Verify Ansible can ping your nodes by running `task ansible:adhoc:ping`
5. Finally, run the Ubuntu Prepare playbook by running `task ansible:playbook:ubuntu-prepare`
6. If everything goes as planned you should see Ansible running the Ubuntu Prepare Playbook against your nodes.
'

printf "\n * Preparing Ubuntu with Ansible\n"

printf " * Install the dependencies from requirements.yml\n\n"
task ansible:deps

printf " * Verify Ansible can view your config\n\n"
task ansible:list

printf " * Verify Ansible can ping your nodes\n\n"
task ansible:adhoc:ping

printf " * Running the Ubuntu Prepare playbook\n\n"
task ansible:playbook:ubuntu-prepare

printf "\n * Ubuntu Prepare completed, proceed to step 4\n\n"