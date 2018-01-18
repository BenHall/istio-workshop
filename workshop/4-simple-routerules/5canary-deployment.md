Think about the following scenario: *Push v2 into the cluster but slowing send end-user traffic to it, if you continue to see success, continue shifting more traffic over time.*

Let's now create a `routerule` that will send 90% of requests to v1 and 10% to v2

Look at the file https://github.com/redhat-developer-demos/istio-tutorial/blob/master/istiofiles/route-rule-recommendations-v1_and_v2.yml

It specifies that `recommendations` with label`version=v1` will have a weight of `90`, and `recommendations` with label`version=v2` will have a weight of `10`

Let's create that routerule: `oc create -f ~/istio-tutorial/istiofiles/route-rule-recommendations-v1_and_v2.yml -n tutorial`{{execute}}

Now perform several requests to the microservices: `curl http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com`{{execute}}


## Recommendations 75/25

Let's change the mixture to be 75/25 by applying the following file https://github.com/redhat-developer-demos/istio-tutorial/blob/master/istiofiles/route-rule-recommendations-v1_and_v2_75_25.yml


Let's replace the previously created routerule with: `oc replace -f ~/istio-tutorial/istiofiles/route-rule-recommendations-v1_and_v2_75_25.yml -n tutorial`{{execute}}

Now perform several requests to the microservices: `curl http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com`{{execute}}

## Cleanup

You can now remove the routerule called `recommendations-v1-v2` to have the load balacing behaviour back.

`oc delete routerule recommendations-v1-v2 -n tutorial`{{execute}}