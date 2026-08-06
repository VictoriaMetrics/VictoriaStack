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

## Single-node or cluster

Every database has a single-node and a clustered version, and both are Apache 2 licensed. You can mix the modes: for example, run clustered
VictoriaMetrics next to single-node VictoriaLogs.

|                   | Single-node                                                | Cluster                                                                                                                                                                                                                  |
|-------------------|------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **What runs**     | one binary per database                                    | separate insert, storage, and select components                                                                                                                                                                          |
| **How to scale**  | vertically: add CPU, RAM, and disk                         | horizontally: add insert/select replicas and storage shards                                                                                                                                                              |
| **Operations**    | one process to run, upgrade, and back up                   | more components, each scaled and upgraded independently                                                                                                                                                                  |
| **Multitenancy**  | VictoriaLogs and VictoriaTraces only                       | all three databases                                                                                                                                                                                                      |
| **Docs**          | [metrics](https://docs.victoriametrics.com/victoriametrics/single-server-victoriametrics/), [logs](https://docs.victoriametrics.com/victorialogs/), [traces](https://docs.victoriametrics.com/victoriatraces/) | [metrics](https://docs.victoriametrics.com/victoriametrics/cluster-victoriametrics/), [logs](https://docs.victoriametrics.com/victorialogs/cluster/), [traces](https://docs.victoriametrics.com/victoriatraces/cluster/) |

<br>

**Start with the single-node version.** It handles workloads far larger than most teams expect, and it keeps
the setup simple. A single node scales vertically, so the first answer to growth is a bigger machine. High availability
can be achieved by running multiple nodes, [replicating traffic](http://localhost:1313/victoriastack/ingestion/#native-ingestion)
to each node and load balancing read requests between them.

Switch a database to the clustered version when:

- one machine can no longer keep up with ingestion or queries, or the data no longer fits its disk;
- you need [multitenancy](http://localhost:1313/victoriastack/multitenancy/) in VictoriaMetrics, which the
  single-node version doesn't support.

The clustered versions use the same three component types in every database, named after their signal:
`vminsert`, `vmselect`, and `vmstorage` for metrics, `vlinsert`, `vlselect`, and `vlstorage` for logs,
`vtinsert`, `vtselect`, and `vtstorage` for traces.
See [Architecture](http://localhost:1313/victoriastack/#architecture) for what each component does.

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
- [VictoriaMetrics Kubernetes Operator](http://localhost:1313/victoriastack/deployment/#victoriametrics-operator): manage VictoriaStack components 
  using Kubernetes-native custom resources.

### Helm Charts

With [VictoriaMetrics K8s Stack](https://docs.victoriametrics.com/helm/victoria-metrics-k8s-stack/) chart you can install
and upgrade a complete VictoriaStack in Kubernetes via [Helm](https://helm.sh/).

By default, the chart installs everything needed to collect metrics, evaluate alerting rules, and visualize the data in
Grafana. Logs and traces storage are disabled by default and can be enabled it in the chart values:

```yaml
# single-node deployments; use vlcluster and vtcluster for the clustered versions
vlsingle:
  enabled: true
vtsingle:
  enabled: true
```

In the chart settings you can configure every component separately, choosing what you actually need.

See the full list of [available charts](https://docs.victoriametrics.com/helm/) for the rest of components.


### VictoriaMetrics Operator

[VictoriaMetrics Kubernetes Operator](https://docs.victoriametrics.com/operator/) makes running VictoriaMetrics 
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

Besides the snapshots API, VictoriaMetrics has more advanced tools for backup management:
[vmbackup](https://docs.victoriametrics.com/victoriametrics/vmbackup/) creates backups and
[vmrestore](https://docs.victoriametrics.com/victoriametrics/vmrestore/) restores them.
[vmbackupmanager](https://docs.victoriametrics.com/victoriametrics/vmbackupmanager/) adds scheduling and backup
retention, so backups need no additional tooling. It is a part of
the [Enterprise package](https://docs.victoriametrics.com/victoriametrics/enterprise/), while vmbackup and vmrestore
are Apache 2 licensed. All three tools are incorporated into Helm charts and the operator.

The same tooling is only about to come to VictoriaLogs and VictoriaTraces - see progress in [issue #123](https://github.com/VictoriaMetrics/VictoriaLogs/issues/123) for more details. 


## Monitoring

The whole VictoriaStack, every component in it was built with monitoring in mind. Every service exposes metrics in 
Prometheus exposition format, produces descriptive logs for significant events, cares about transparency of internal processes.

VictoriaStack components are shipped together with descriptive, production-ready Grafana dashboards available at
[grafana.com/victoriametrics/dashboards](https://grafana.com/orgs/victoriametrics/dashboards). The dashboards are
constantly updated and maintained by the VictoriaMetrics team.

The same goes for the alerting. You can find the list of recommended alerting rules to run with the stack below:
- [VictoriaMetrics rules](https://github.com/VictoriaMetrics/VictoriaMetrics/tree/master/deployment/docker/rules)
- [VictoriaLogs rules](https://github.com/VictoriaMetrics/VictoriaLogs/tree/master/deployment/docker/rules)
- [VictoriaTraces rules](https://github.com/VictoriaMetrics/VictoriaTraces/tree/master/deployment/docker/rules)

Alerting rules are closely interconnected with the Grafana dashboards, providing transparent monitoring experience for 
the end-users. 

The alerting rules and Grafana dashboards bring high value and are always up to date because VictoriaMetrics team is 
dogfooding the whole stack internally, in cloud and for Enterprise customers.