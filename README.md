# meetup-rvk-demo

## Why 
Stop feeding your cluster with human blood. Creating controlled chaos forces SRE and developers to increase resiliency and decrease late night phone calls or hours spent in war rooms doing all kinds of damage control.  

There is more to chaos engineering than just randomly shutting down instances.

You take a part of the system,  define its steady state and design an experiment that either should or should not affect the system.  Release the kraken and observe the results.

This creates a set of controlled experiments that can be scheduled to run randomly, in coordination with updates or perhaps on a regular basis. 

https://principlesofchaos.org/?lang=ENcontent

## How
           
Define system steady state

Form a hypothesis 

Create the chaos engine to simulate the experiment

Create a rollback strategy and/or abort procedure

Deploy 

Observe the result 

Schedule 

## Stack 
The monkey stack
A well designed chaos ecosystem could include more monkeys than just the one that breaks instances.  
Netflix had a (now retired) set of tools called Simian Army. The basic ideas of the simian army are still highly relevant 

* Janitor monkey 

A robot that will ruthlessly clean up unused resources  

* Conformity monkey 

This robot will tear down any stack/resource that does not adhere to preset architectural rules, for example a cluster that has its admin interface exposed to the internet.  

* Security Monkey 

Whitehat pentest your own systems 

* Latency monkey 

### Preliminary monkey stack at NetApp
Litmus: for k8s   
Chaostookit: for infrastructure   
Argo and ArgoCD: for delivery  (Alpha)   
Grafana loki: for log aggregation with fluentbit (memory issues with promtail we use the still experimental boltdb for storage )     
     Index: Amazon dynamodb - Cassandra - Bigtable  we use boltDB       Storage: all above s3 filesystem , we use filesystem   
     Prometheus+Grafana      Blackbox exporter and Pushgateway as litmus engines are scheduled jobs  
Linkerd: for service mesh  
Weavescope: for graphical cluster representation   


## Use cases
One of the trickier issues to identify is often when network connectivity starts behaving in an unexpected way. This would be a way of identifying how a system behaves during 

Customer induced retry storm 
Cascading failures 
Accidental complexity
And could be a valuable tool to identify business and application logic mismatch 

There are many more parts of the stack. Chaos engineering as a field is growing.  