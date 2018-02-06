#!/bin/bash
ssh root@host01 "rm -rf /root/projects/rhoar-getting-started /root/temp-pom.xml"

ssh root@host01 "mkdir -p /root/installation"
ssh root@host01 "wget https://github.com/istio/istio/releases/download/0.5.0/istio-0.5.0-linux.tar.gz -P /root/installation"
ssh root@host01 "tar -zxvf /root/installation/istio-0.5.0-linux.tar.gz -C /root/installation"

ssh root@host01 "sleep 10; oc login -u system:admin; oc adm policy add-cluster-role-to-user cluster-admin admin"

ssh root@host01 "oc adm policy add-cluster-role-to-user cluster-admin developer"
ssh root@host01 "oc adm policy add-scc-to-user anyuid -z istio-ingress-service-account -n istio-system"
ssh root@host01 "oc adm policy add-scc-to-user anyuid -z istio-egress-service-account -n istio-system"
ssh root@host01 "oc adm policy add-scc-to-user anyuid -z default -n istio-system"

ssh root@host01 "oc apply -f /root/installation/istio-0.5.0/install/kubernetes/istio.yaml"

ssh root@host01 "oc expose svc istio-ingress -n istio-system"

