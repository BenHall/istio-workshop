Wait only N seconds before giving up and failing. At this point, no other route rules should be in effect. Perform and 
`oc get routerules`{{execute T1}} and maybe and `oc delete routerule {rulename}`{{execute T1}} if there are some.

First, introduce some wait time in recommendations v2 by uncommenting the line 40 that call the timeout method. This method, will cause a wait time of 3 seconds. Update `/recommendation-v2/src/main/java/com/redhat/developer/demos/recommendation/RecommendationVerticle.java`{{open}} making it a slow perfomer. 

```java
@Override
    public void start() throws Exception {
        Router router = Router.router(vertx);
        router.get("/").handler(this::logging);
        router.get("/").handler(this::timeout);
        router.get("/").handler(this::getRecommendations);
        router.get("/misbehave").handler(this::misbehave);
        router.get("/behave").handler(this::behave);

        HealthCheckHandler hc = HealthCheckHandler.create(vertx);
        hc.register("dummy-health-check", future -> future.complete(Status.OK()));
        router.get("/health").handler(hc);

        vertx.createHttpServer().requestHandler(router::accept).listen(8080);
    }
```

**Note:** The file is saved automatically.

Rebuild and redeploy the recommendation microservices.

Go to the recommendation folder `cd ~/projects/istio-tutorial/recommendation-v2/`{{execute T1}}

Compile the project with the modifications that you did.

`mvn package`{{execute T1}}

Execute `docker build -t example/recommendation:v2 .`{{execute T1}}

You can check the image that was create by typing `docker images | grep recommendation`{{execute T1}}

Now let's delete the previous v2 pod to force the creation of a new pod using the new image.

`oc delete pod -l app=recommendation,version=v2 -n tutorial`{{execute T1}}

To watch the creation of the pods, execute `oc get pods -w`{{execute T1}}

Once that the recommendation pods READY column are 2/2, you can hit `CTRL+C`. 

## Timeout rule

Check the file `/istiofiles/route-rule-recommendation-timeout.yml`{{open}}.

Note that this `RouteRule` provides a `simpleTimeout` of `1 second`.

Let's apply this rule: `oc create -f ~/projects/istio-tutorial/istiofiles/route-rule-recommendation-timeout.yml -n tutorial`{{execute T1}}

You will see it return `v1` OR `upstream request timeout` after waiting about 1 second, although v2 takes 3 seconds to complete.

To check the new behaviour, try the microservice several times by typing `while true; do curl http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com; sleep .1; done`{{execute T1}}

Hit CTRL+C when you are satisfied.

## Clean up

To remove the Timeout behaviour, simply delete this `routerule` by executing `oc delete routerule recommendation-timeout -n tutorial`{{execute T1}}

To check if you have random load-balance, try the microservice several times by typing `while true; do curl http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com; sleep .1; done`{{execute T1}}

Hit CTRL+C when you are satisfied.