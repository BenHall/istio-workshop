To send a file to `v1` and `v2` by simply removing the rule

`oc delete routerules/recommendation-default -n tutorial`{{execute T1}}

Then you should see the default behavior of load-balancing between v1 and v2

Try the microservice several times by typing `while true; do curl http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com; sleep .1; done`{{execute T1}}

Hit CTRL+C when you are satisfied.