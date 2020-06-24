 ![alt text](resources/img/litmus_logo.png "LitmusChaos")  
 # Litmus chaos engine experiments
For more information go to https://docs.litmuschaos.io/docs/chaosengine/
## About
> Litmus is an open source chaos engine, it is a wrapper around a few external tools and makes use of them via ansible to inject chaos into k8s clusters. The project is in its early stages (as of may 2020) but can be considered stable. There is no UI to speak of as of yet. Litmus contributors have started looking into ArgosCD piplines for that purpose  

The chaos experiment (triggered after creation of the chaosEngine resource) workflow consists of launching the “chaos-runner” pod, which is an umbrella executor of different chaos experiments listed in the engine.  
The chaos-runner creates one pod (job) per each experiment to run the actual experiment business logic, and also manages the lifecycle of these experiment pods (performs functions such as experiment dependencies validation, job cleanup, patching of status back into chaosEngine etc.,).  
Optionally, a monitor pod is created to export the chaos metrics.  
Together, these 3 pods are a standard set created upon execution of the experiment.  
The experiment job, in turn may spawn dependent (helper) resources if necessary to run the experiments, but this depends on the experiment selected, chaos libraries chosen etc. 

### Chaoskube
Chaoskube is designed to periodically kill random pods  
### Chaostoolkit
The chaostoolkit is another chaos framework and, like litmus plugin, it's still in its early stages. Chaos toolkit includes a wider array of chaos experiments than litmus, such as infrastructure plugins for all the hyperscalers. Chaos toolkit plugin maintenance varies heavily. The hyperscaler experiments and the k8s plugins are actively maintained.  
### Litmus
Litmus is a collection of chaos tools for k8s installed via an operator to create custom resources they are  
- ChaosExperiments  
    Individually downloaded CR from https://hub.litmuschaos.io/
- ChaosEngine
    The experiment
- ChaosResults
    The results are stored in the results resource but the metrics are also exported via chaos-exporter. The metrics are formatted for prometheus  
### Powerfulseal
Powefulseal is designed for k8s to kill pods but also to take down VMs and works with all the major hyperscalers. It exposes metrics in prometheus format but also have datadog support
### Pumba
Pumba is a network manipulation and stress testing tool designed for containers that make use of the containerd runtime. It uses netem https://wiki.linuxfoundation.org/networking/netem a network emulator . Netem is dependent on *tc* Linux traffic control http://www.tldp.org/HOWTO/html_single/Traffic-Control-HOWTO/   
### Ansible 
Litmus makes heavy use of ansible to deploy experiments and retreive their results. Ansible is an automation framework from redhat. It is written in python and commonly used to deploy infrastructure and software across platforms and hyperscalers.   
In the last community meetup it was announced that ansible is going to be phased out in favour of golang
## Creating an experiment 
```yaml
apiVersion: litmuschaos.io/v1alpha1
kind: ChaosEngine
metadata:
  name: meteorqloud-chaos
  namespace: default
spec:
  # Mandatory: Select resource to experiment on 
  appinfo:
    appns: 'default'
    applabel: 'app=meteorqloud'
    appkind: 'deployment'
  # Optional: Annotations are recommended to control blast radius. Default is true 
  annotationCheck: 'false'
  # Mandatory: Tell the chaosengine is preffered status, this flag is solely used to patching the engine to abort the experiment
  engineState: 'active'
  # Optional: Add one or more namespace/label paris whose health is also monitored as a part of the chaos experiment
  # id addition to the applicaton specified in appInfo, apps that are dependent on the imacted on downstream  
  # the format is namespace: label=value eg: default:app=nginx
  auxiliaryAppInfo: ''
  # Mandatory: Best practice is to create a unique SA per experiment
  chaosServiceAccount: pod-delete-sa
  # Optional: Collect experiment metrics via an exported pod 
  # requires the chaos exporter to be installed
  monitoring: true
  # Mandatory: Retain or delete the chosexperiment job after run. 
  # retain is meant for debugging purposes, default is delete
  jobCleanUpPolicy: 'delete'
  experiments:
    - name: pod-delete
      spec:
        components:
          env:
            # set chaos duration (in sec) as desired
            - name: TOTAL_CHAOS_DURATION
              value: '30'

            # set chaos interval (in sec) as desired
            - name: CHAOS_INTERVAL
              value: '10'

            # pod failures without '--force' & default terminationGracePeriodSeconds
            - name: FORCE
              value: 'false'

            # The amount of pods that should be deleted
            - name: KILL_COUNT
              value: '2'
```

## Monitoring experiments

Litmus comes with a separate chaos-exporter that exports performance metrics and experiment results formatted for prometheus scraping.  
To make use of the exporter set the experiment to false . 

Chaos-operator logs  
```bash
kubectl logs -f <chaos-operator-(hash)-(hash)>-runner -n litmus
```

Lifecycle management logs of a given (or set of) chaos experiments look at the chaos-runner
```bash
kubectl logs -f <chaosengine_name>-runner -n <application_namespace>
```


To view the chaos logs itself (details of experiment chaos injection, application health checks) 
experiment pod logs:
```bash
kubectl logs -f <experiment_name_(hash)_(hash)> -n <application_namespace>
```

The chaos-operator generates Kubernetes events to signify the creation of removal of chaos resources over the course of a chaos experiment
```bash
kubectl describe chaosengine <chaosengine-name> -n <namespace>
```
 
