---
title: Deployment
menu:
  docs:
    weight: 1
    identifier: victoriastack-deployment
    parent: victoriastack
tags:
  - metrics
  - logs
  - traces
---

VictoriaStack consists of multiple components that can be deployed together or separately, in many different ways and
in different environments:
- [Local or bare metal](#local--bare-metal) deployments require more actions to compose components together but provide the most flexibility.
- [Kubernetes deployments](#kubernetes) are easier to set up and run thanks to helm charts and operator.

Choose what suits your needs best.

## Local / Bare Metal

All VictoriaStack components have extensive Quick Start instructions for running in various environments:
- [VictoriaMetrics Quick Start](https://docs.victoriametrics.com/victoriametrics/quick-start/) (metrics)
- [VictoriaLogs Quick Start](https://docs.victoriametrics.com/victorialogs/quick-start/) (logs)
- [VictoriaTraces Quick Start](https://docs.victoriametrics.com/victoriatraces/quick-start/) (traces)
- [vmauth Quick Start](https://docs.victoriametrics.com/victoriametrics/vmauth/) (authentication, routing, load balancing)
- [vmalert Quick Start](https://docs.victoriametrics.com/victoriametrics/vmalert/#quickstart) (alerting)

See references to the specific documentation in sections below.

### Binary

VictoriaStack components binaries can be downloaded from the GitHub releases page:
- [VictoriaMetrics relases](https://github.com/VictoriaMetrics/VictoriaMetrics/releases)
- [VictoriaLogs relases](https://github.com/VictoriaMetrics/VictoriaLogs/releases)
- [VictoriaTraces relases](https://github.com/VictoriaMetrics/VictoriaTraces/releases)

On releases page you can also find `vmutils` and `vlutils` packages that contain components like
[vmauth](https://docs.victoriametrics.com/vmauth/), [vmalert](https://docs.victoriametrics.com/vmalert/),
[vmagent](https://docs.victoriametrics.com/vmagent/), [vlagent](https://docs.victoriametrics.com/victorialogs/vlagent/), etc.

When downloading the archives with binaries, remember to choose architecture that matches your environment.
See detailed instructions on downloading and running binaries:
- [VictoriaMetrics: try it locally](https://docs.victoriametrics.com/victoriametrics/quick-start/#try-it-locally)
- [VictoriaLogs: try it locally](https://docs.victoriametrics.com/victorialogs/quickstart/#try-it-locally)
- [VictoriaTraces: try it locally](https://docs.victoriametrics.com/victoriatraces/quick-start/#starting-victoriatraces-single-node-from-a-binary)

### Docker

VictoriaStack components Docker images can be found on [Docker Hub](https://hub.docker.com/u/victoriametrics) and 
[Quay](https://quay.io/repository/victoriametrics/victoria-metrics?tab=tags).

### Docker Compose

Docker Compose examples for running VictoriaStack components can be found on [VictoriaStack/QuickStart page](http://localhost:1313/victoriastack/#quick-start).

## Kubernetes

VictoriaStack can be deployed on Kubernetes in two ways:

- [Helm Charts](http://localhost:1313/victoriastack/deployment/#helm-charts): install and upgrade a complete VictoriaStack using [Helm](https://helm.sh/)
- [VictoriaMetrics Kuberentes Operator](http://localhost:1313/victoriastack/deployment/#victoriametrics-operator): manage VictoriaStack components 
  using Kubernetes-native custom resources.

### Helm Charts

With [VictoriaMetrics K8s Stack](https://docs.victoriametrics.com/helm/victoria-metrics-k8s-stack/) chart you can install
and upgrade a complete VictoriaStack in Kubernetes via [Helm](https://helm.sh/).

With this chart installed, you will get all required resources to collect metrics, logs and traces, run alerting,
Grafana for visualization. In the chart settings you can configure every component separately, choosing what you 
actually need.

See the full list of [available charts](https://docs.victoriametrics.com/helm/) for the rest of components.


### VictoriaMetrics Operator

[VictoriaMetrics Kuberentes Operator](https://docs.victoriametrics.com/operator/) makes running VictoriaMetrics 
applications on top of Kubernetes as easy as possible while preserving Kubernetes-native configuration options.
It allows you to manage Victoria Metrics components in Kubernetes or OpenShift clusters in a declarative style following
[GitOps](https://www.redhat.com/en/topics/devops/what-is-gitops) and [IaC](https://en.wikipedia.org/wiki/Infrastructure_as_code) concepts.

See [Quick Start instructions](https://docs.victoriametrics.com/operator/quick-start/) for the operator.

## Backups

Backups in VictoriaStack are implemented using data snapshots - an instanteneous mechanism for making a copy of the data
within a second and without any impact on the database. The snapshots then can be uploaded to any durable storage
like S3 for storing backups:
- [VictoriaMetrics backups management: vmbackup, vmrestore, vmbackupmanager](https://docs.victoriametrics.com/victoriametrics/vmbackup/)
- [VictoriaLogs backup and restore](https://docs.victoriametrics.com/victorialogs/#backup-and-restore)
- [VictoriaTraces backup and restore](https://docs.victoriametrics.com/victoriatraces/#backup-and-restore)

Besides snapshots API, VictoriaMetrics has more advanced tools for backup management: [vmbackup](https://docs.victoriametrics.com/victoriametrics/vmbackup/),
[vmrestore](https://docs.victoriametrics.com/victoriametrics/vmrestore/) and [vmbackupmanager](https://docs.victoriametrics.com/victoriametrics/vmbackupmanager/).
With these tools, it is possible to schedule and automate backups management without additional tooling. These tools
are also incorportated into helm charts and operator.

The same tooling is only about to come to VictoriaLogs and VictoriaTraces - see progress in [issue #123](https://github.com/VictoriaMetrics/VictoriaLogs/issues/123) for more details. 


## Monitoring

The whole VictoriaStack, every component in it was built with monitoring in mind. Every service exposes metrics in 
Prometheus exposition format, produces descriptive logs for significant events, cares about transparency of internal processes.

VictoriaStack components are shipped together with descriptive, production-ready Grafana dashboards available at
[grafana.com/victoriametrics/dashboards](https://grafana.com/orgs/victoriametrics/dashboards). The dashboards are
constantly updated and maintained by the VictoriaMetrics team.

The same goes for the alerting. You can find the list of recommended alerting rules to run with the stack below:
- [VictoriaMetrics rules](https://github.com/VictoriaMetrics/VictoriaMetrics/tree/master/deployment/docker/rules)
- [VictoriaLogs rules](https://github.com/VictoriaMetrics/Victorialogs/tree/master/deployment/docker/rules)
- [VictoriaTraces rules](https://github.com/VictoriaMetrics/Victoriatraces/tree/master/deployment/docker/rules)

Alerting rules are closely interconnected with the Grafana dashboards, providing transparent monitoring experience for 
the end-users. 

The alerting rules and Grafana dashboards bring high value and are always up to date because VictoriaMetrics team is 
dogfooding the whole stack internally, in cloud and for Enterprise customers.