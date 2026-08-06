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
the setup simple. A single node scales vertically, so the first answer to growth is a bigger machine.
[High availability](#high-availability) can be achieved by running multiple nodes,
[replicating traffic](http://localhost:1313/victoriastack/ingestion/#native-ingestion) to each node and load balancing
read requests between them.

Switch a database to the clustered version when:

- one machine can no longer keep up with ingestion or queries, or the data no longer fits its disk;
- you need [multitenancy](http://localhost:1313/victoriastack/multitenancy/) in VictoriaMetrics, which the
  single-node version doesn't support.

The clustered versions use the same three component types in every database, named after their signal:
`vminsert`, `vmselect`, and `vmstorage` for metrics, `vlinsert`, `vlselect`, and `vlstorage` for logs,
`vtinsert`, `vtselect`, and `vtstorage` for traces.
See [Architecture](http://localhost:1313/victoriastack/#architecture) for what each component does.

## High availability

All three databases achieve high availability the same way: run two or more independent installations and replicate
every record to each of them. An agent in front of the databases sends the copies and buffers the data for
installations that are temporarily unavailable, while
[vmauth](https://docs.victoriametrics.com/victoriametrics/vmauth/#load-balancing) balances read requests among the
healthy ones. There is no consensus protocol and no coordination between the installations, which keeps the scheme
simple to run and to troubleshoot.

| Signal      | HA docs                                                                                                             | What replicates the data                                                                               |
|-------------|---------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------|
| **Metrics** | [VictoriaMetrics](https://docs.victoriametrics.com/victoriametrics/single-server-victoriametrics/#high-availability) | [vmagent](https://docs.victoriametrics.com/victoriametrics/vmagent/#replication-and-high-availability) |
| **Logs**    | [VictoriaLogs](https://docs.victoriametrics.com/victorialogs/#high-availability)                                    | [vlagent](https://docs.victoriametrics.com/victorialogs/vlagent/#replication-and-high-availability)    |
| **Traces**  | [VictoriaTraces](https://docs.victoriametrics.com/victoriatraces/#high-availability)                                | OpenTelemetry collector, or any shipper that writes to multiple destinations    // TODO: READINESS: vtagent for replication|

<br>



The scheme works the same way for single-node and for clustered installations, within one availability zone or across
several. Run the stateless components in more than one replica as well: vmagent, vlagent, vmauth, vmalert, and
Alertmanager.

Replication protects against losing a node or a zone. It does not protect against a bad config, a wrong upgrade, or an
accidental deletion, since those reach every replica. Keep [backups](#backups) as well.

On Kubernetes, the operator can manage this whole topology as a single resource.
See [high availability in Kubernetes](#high-availability-in-kubernetes).

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

[VictoriaMetrics operator](#victoriametrics-operator) runs every component of the stack through Kubernetes custom resources,
and the [k8s-stack chart](#helm-charts) installs the operator together with those resources. 

Pick the entry point that matches how you manage Kubernetes:

- **[k8s-stack chart](#helm-charts)**: the fastest way to a complete stack. One Helm release brings the operator, the
  databases, agents, alerting rules, Grafana, and the scrape configs for the cluster itself. Every component is still
  configured through its custom resource, under the `spec` key in the chart values.
- **[Operator](#victoriametrics-operator)**: install the operator alone and write the custom resources yourself. This
  suits teams that keep manifests in Git and apply them with ArgoCD, Flux, or similar tooling, and installations that
  need a layout the chart doesn't cover.
- **Single-component charts**: use [one of the other charts](https://docs.victoriametrics.com/helm/), such as
  `victoria-metrics-single` or `victoria-logs-single`, when you need one component rather than the whole stack.

### Helm Charts

With [VictoriaMetrics K8s Stack](https://docs.victoriametrics.com/helm/victoria-metrics-k8s-stack/) chart you can install
and upgrade a complete VictoriaStack in Kubernetes via [Helm](https://helm.sh/). Alongside the VictoriaStack components
the chart installs the operator, Grafana, kube-state-metrics, and node-exporter as dependency charts. Each of them can be
disabled in the values, for example to reuse a Grafana or an operator you already run.

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

[VictoriaMetrics Kubernetes Operator](https://docs.victoriametrics.com/operator/) manages VictoriaStack components in
Kubernetes and OpenShift clusters via custom resources. Describe the desired state via
[resources](https://docs.victoriametrics.com/operator/resources/) such as `VMCluster`, `VLSingle`, or `VMAgent`, and the
operator will create and update the installation behind it.

For metrics, operator picks up scrape configuration on its own: it discovers `VMServiceScrape` and similar resources, and
[converts existing prometheus-operator objects](https://docs.victoriametrics.com/operator/integrations/prometheus/#objects-conversion)
such as `ServiceMonitor` into their VictoriaMetrics equivalents. Existing Prometheus setups keep working after the
migration.

See [Quick Start instructions](https://docs.victoriametrics.com/operator/quick-start/) for the operator.

### High availability in Kubernetes

// TODO: READINESS: VTDistributed

// TODO: READINESS: VLDistributed/VMDistributed are marked as experimental

The operator describes a multi-zone installation as a single resource:
[VMDistributed](https://docs.victoriametrics.com/operator/resources/vmdistributed/) for metrics
and [VLDistributed](https://docs.victoriametrics.com/operator/resources/vldistributed/) for logs. Each of them takes a
list of zones and creates, for every zone, the database plus an agent that replicates writes into it. All zones use the
same backend type: either the clustered or the single-node version of the database. A shared vmauth in front of the
zones acts as the global read and write entrypoint, so producers and Grafana keep using one address no matter how many
zones exist.

The operator applies changes to the zones sequentially, and each zone can be switched between serving reads, writes,
both, or nothing at all. An upgrade or a maintenance window therefore takes one zone out of rotation at a time, while
the remaining zones keep ingesting and answering queries.

The [k8s-stack chart](https://docs.victoriametrics.com/helm/victoria-metrics-k8s-stack/) creates these resources from
its values:

```yaml
# metrics: mutually exclusive with vmsingle and vmcluster
vmdistributed:
  enabled: true

# logs: mutually exclusive with vlsingle and vlcluster; needs chart v0.90.0 or newer
vldistributed:
  enabled: true
```

The operator also documents high availability
for [every individual resource](https://docs.victoriametrics.com/operator/resources/#high-availability) it manages,
including vmagent, vlagent, vmauth, vmalert, and Alertmanager.

## Upgrades

Upgrades and downgrades are safe unless the release notes say otherwise. Skipping versions is safe too. Check the
changelog before upgrading: [metrics](https://docs.victoriametrics.com/victoriametrics/changelog/),
[logs](https://docs.victoriametrics.com/victorialogs/changelog/),
[traces](https://docs.victoriametrics.com/victoriatraces/changelog/). The databases are released separately, so
upgrade each of them on its own schedule.

Upgrading a single-node database takes three steps:

1. Send `SIGINT` to the process to stop it gracefully.
2. Wait until the process exits. This can take a few seconds.
3. Start the new version with the same data directory and flags.

Most agents keep buffering data while a database restarts, so nothing is lost during the gap.
See the detailed docs on upgrading
[VictoriaMetrics](https://docs.victoriametrics.com/victoriametrics/single-server-victoriametrics/#how-to-upgrade-victoriametrics),
[VictoriaLogs](https://docs.victoriametrics.com/victorialogs/#upgrading), [VictoriaTraces](https://docs.victoriametrics.com/victoriatraces/#upgrading).

In Kubernetes, the operator manages the restarts. Pin the version of every component
via [`spec.image.tag`](https://docs.victoriametrics.com/operator/resources/#managing-versions-of-vm), and the operator
rolls out the change. Multi-zone installations managed
by [VMDistributed or VLDistributed](#high-availability-in-kubernetes) upgrade one zone at a time, so the remaining
zones keep serving traffic.

Teams that prefer rare, low-risk updates can follow the long-term support release lines instead of the latest release.
LTS releases are published for VictoriaMetrics only and are part of the Enterprise package,
see [Long-term support releases](http://localhost:1313/victoriastack/enterprise/#long-term-support-releases).

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
the [Enterprise package](http://localhost:1313/victoriastack/enterprise/), while vmbackup and vmrestore
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