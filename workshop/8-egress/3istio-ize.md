Open the file `istiofiles/egress_httpbin.yml`{{open}}.

Note that it allows access to `httpbin.org` on the port `80`

Let's apply this file.

`oc create -f ~/projects/istio-tutorial/istiofiles/egress_httpbin.yml -n istioegress`{{execute}}

Check the existing `egressrules`: `istioctl get egressrules`{{execute}}

Try the microservice by typing `curl http://egresshttpbin-istioegress.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com`{{execute}}

Alternativally you can shell into the pod by getting its name and then using that name with oc exec

`oc exec -it $(oc get pods -o jsonpath="{.items[*].metadata.name}" -l app=egresshttpbin,version=v1) -c egresshttpbin /bin/bash`{{execute}}

Try the following commands:

- `curl localhost:8080`{{execute}}
- `curl httpbin.org/user-agent`{{execute}}
- `curl httpbin.org/headers`{{execute}}

Exit from the pod: `exit`{{execute}}

## Istio-ize egressgithub

You can create YAML files from command lines by passing it to `istioctl` via `cat <<EOF |`

Execute:

```
cat <<EOF | istioctl create -f -
apiVersion: config.istio.io/v1alpha2
kind: EgressRule
metadata:
    name: google-egress-rule
spec:
    destination:
        service: www.google.com
    ports:
      - port: 443
        protocol: https
EOF
```{{execute}}

and shell into the github pod for testing google access: `oc exec -it $(oc get pods -o jsonpath="{.items[*].metadata.name}" -l app=egressgithub,version=v1) -c egressgithub /bin/bash`{{execute}}

Try to access google: `curl http://www.google.com:443`{{execute}}

Exit from the pod: `exit`{{execute}}

Open the file `istiofiles/egress_github.yml`{{open}}.

Note that it allows access to `api.github.com` on the port `443`

Now, apply the egressrule for github:

`oc create -f ~/projects/istio-tutorial/istiofiles/egress_github.yml -n istioegress`{{execute}}

And execute the Java code that hits api.github.com/users `curl http://egressgithub-istioegress.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com`{{execute}}

## Clean up

Remove the egress rules

`oc delete egressrule httpbin-egress-rule google-egress-rule github-egress-rule`{{execute}}