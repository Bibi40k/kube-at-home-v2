#!/usr/bin/env bash

REPOURL="https://github.com/k8s-at-home/template-cluster-k3s"

git remote add template $REPOURL
git fetch --all
git merge template/main --allow-unrelated-histories