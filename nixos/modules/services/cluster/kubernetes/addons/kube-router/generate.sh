#!/usr/bin/env bash

release="v0.2.1"
curl --fail "https://raw.githubusercontent.com/cloudnativelabs/kube-router/${release}/daemonset/generic-kuberouter-all-features.yaml" > ./kuberouter.yaml
sed -i 's/%CLUSTERCIDR%/@CLUSTERCIDR@/g' ./kuberouter.yaml
sed -i 's/%APISERVER%/@APISERVER@/g' ./kuberouter.yaml

