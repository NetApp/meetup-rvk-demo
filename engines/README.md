 ![alt text](resources/img/sopranos.jpg "LitmusChaos") 
# Chaos in Cloud Volumes
Early stage POC assignment to test out the effectiveness and hopefully incident reduction by purposefully injecting faults into our infrastrucure.  
To be successful using this methodology the chaos engineering community recommends creating experiments by using these steps
  
Once you have decided on one resource to inject chaos into do the following
### 1) Define steady state
First define how to measure what the normal and healthy state of the resource is 
### 2) Form a hypothesis
Create a guideline for what results are expected from the chaos experiment
### 3) Create a chaos engine
Create the engine itself , taking into account metrics collection of any possible downstream resources 
### 4)  Create a rollback strategy | Abort
Create a strategy to abort the experiment. CHaos engineering is supposed to run in production systems to be properly useful. Make sure there is a good rollback strategy should the experminet create unexpected consequences or if an unrelated event calls for immediate cancellation
### 5)  Deploy
Run the Engine , this should be designed so it can run without manual labour. Engines should be either randomized or scheduled to run at a specific time for example after / during upgrades, New features etc. 
### 6) Note the result
Make sure the result is collected and kept for analysis. This also calls for the observability stack to support metrics of the chaos engine and alerting on unexpected results
### 7 ) Schedule | CD pipeline
Automate the engine runs as is needed. Note , the goal is to run chaos in production clusters.
