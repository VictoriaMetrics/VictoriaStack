---
title: Comparisons
menu:
  docs:
    weight: 7
    identifier: victoria-stack-comparisons
    parent: victoria-stack
tags:
  - metrics
  - logs
  - traces
---

This page compares VictoriaStack with the most popular alternatives, so you can pick the right tool
for your requirements.

> **How to read this comparison.** VictoriaMetrics maintainers wrote this page, so bias is possible despite our
> best efforts. We only make claims we can back with sources, and we list the cases where competitors are a better fit.
> If you find an outdated or wrong statement,
> please [open an issue](https://github.com/VictoriaMetrics/VictoriaStack/issues).
> Verify performance claims on **your** workload: we provide links to our benchmarks for reference.

## Design philosophies

Open-source observability stacks follow one of the following architectural philosophies:

1. **A specialized database per signal** (*VictoriaStack, Grafana LGTM*).
   Each signal (metrics, logs, traces) gets a database optimized for its access patterns, accessed via a unified UI.
   Provides the highest efficiency and flexibility, as each signal is processed via a specialized optimized pipeline and
   can be scaled independently.
2. **One general-purpose database for all signals** (*ClickStack, SigNoz, Elastic Stack*).
   All signals land in a single analytical database with a bundled UI on top. You get maximum query flexibility,
   often in SQL. The cost is running a general-purpose database, not specialized for any single signal in particular.

**Neither philosophy is universally better.** The rest of this page explains the practical consequences.

## At a glance

|                             | **VictoriaStack**                                                                                                                                             | **Grafana LGTM**                         | **ClickStack**                                                                                                                                                 | **SigNoz**                                                                                 | **Elastic Stack**                   |
|-----------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------|-------------------------------------|
| **Signals**                 | Metrics, logs, traces                                                                                                                                         | Metrics, logs, traces                    | Metrics, logs, traces                                                                                                                                          | Metrics, logs, traces                                                                      | Metrics, logs, traces               |
| **License**                 | [Apache 2.0](https://github.com/VictoriaMetrics/VictoriaMetrics/blob/master/LICENSE)                                                                          | [AGPLv3](https://grafana.com/licensing/) | [ClickHouse: Apache 2.0](https://github.com/ClickHouse/ClickHouse/blob/master/LICENSE), [HyperDX: MIT](https://github.com/hyperdxio/hyperdx/blob/main/LICENSE) | [Apache 2, separate license for `ee/`](https://github.com/SigNoz/signoz/blob/main/LICENSE) | Elastic License 2.0 / SSPL / AGPLv3 |
| **Query languages**         | [MetricsQL](https://docs.victoriametrics.com/victoriametrics/metricsql/) (PromQL-compatible), [LogsQL](https://docs.victoriametrics.com/victorialogs/logsql/) | PromQL, LogQL, TraceQL                   | SQL, Lucene-style search                                                                                                                                       | PromQL, SQL                                                                                | ES QL, KQL, Lucene                  |
| **OpenTelemetry ingestion** | Yes                                                                                                                                                           | Yes                                      | Yes                                                                                                                                                            | Yes                                                                                        | Yes                                 |
| **Horizontal scalability**  | Yes                                                                                                                                                           | Yes                                      | Yes                                                                                                                                                            | Yes                                                                                        | Yes                                 |
| **Multitenancy**            | Via labels or HTTP headers                                                                                                                                    | Via HTTP headers                         | Via ClickHouse databases/RBAC                                                                                                                                  | Single-tenant self-hosted, via organizations in Cloud                                      | Via Spaces/RBAC                     |
| **Bundled UI**              | [vmui](https://docs.victoriametrics.com/victoriametrics/#vmui) for ad-hoc queries; Grafana for dashboards and correlation                                     | Grafana                                  | HyperDX (unified)                                                                                                                                              | SigNoz UI (unified)                                                                        | Kibana (unified)                    |
| **Kubernetes**              | [Operator](https://docs.victoriametrics.com/operator/) + [Helm charts](https://docs.victoriametrics.com/helm/) covering the full stack                        | Helm charts, Grafana Operator            | Helm charts                                                                                                                                                    | Helm charts                                                                                | ECK operator                        |

## VictoriaStack vs Grafana LGTM (Mimir + Loki + Tempo)

The LGTM stack is the closest architectural relative of VictoriaStack. Both use specialized databases for each signal,
and both use Grafana as the primary visualization layer.

**Key differences:**

* **Operational model.** LGTM components scale by splitting work across microservice roles: distributor, ingester,
  querier, compactor, and others. This design scales well, but it also adds more components to configure, monitor, and upgrade.
  VictoriaStack databases run as single binaries.
  [Cluster versions](https://docs.victoriametrics.com/victoriametrics/cluster-victoriametrics/) use three simple roles.
  That means fewer components to operate.
* **Resource usage.** VictoriaMetrics typically needs less RAM and CPU than Mimir on the same workload.
  See the [published benchmarks](https://victoriametrics.com/blog/mimir-benchmark/) from 2022.
  Since then, both Mimir and VictoriaMetrics have gone through many changes, so it is recommended to benchmark on your
  own workload.
  For logs, see
  the [VictoriaLogs vs Loki benchmarks](https://docs.victoriametrics.com/victorialogs/faq/#how-does-victorialogs-compare-to-loki)
  and third-party reports such
  as [TrueFoundry's migration from Loki](https://www.truefoundry.com/blog/victorialogs-vs-loki).
* **Storage.** LGTM stack natively supports S3 for historical data, storing recent data on the local file system and uploading historical
  data to S3. VictoriaStack relies on the local file system for the stored data,
  and S3 support only for backups. There is ongoing work to [support S3 for historical data](https://github.com/VictoriaMetrics/VictoriaLogs/issues/48) in VictoriaStack. 
* **Query languages.** Mimir, Loki, and Tempo use PromQL, LogQL, and TraceQL.
  VictoriaStack uses [MetricsQL](https://docs.victoriametrics.com/victoriametrics/metricsql/)
  and [LogsQL](https://docs.victoriametrics.com/victorialogs/logsql/).
  MetricsQL is a PromQL superset with
  [documented intentional differences](https://medium.com/@romanhavronenko/victoriametrics-promql-compliance-d4318203f51e).
  LogsQL queries both logs and traces.
* **Grafana integration.** The LGTM stack is developed by Grafana Labs and integrates naturally with Grafana. 
  Third-party datasource plugins do not have the same level of native integration.
* **License.** LGTM projects use the AGPLv3 license. VictoriaStack uses Apache 2.0.
  For most end users there is no practical difference between the licenses. 
  For teams that embed the databases into distributed products, Apache 2.0 is simpler to adopt.

**Prefer LGTM when:**

* You require strict PromQL compatibility.
* Your organization already invests heavily in Grafana Cloud tooling.

**Prefer VictoriaStack when:**

* You want the smallest operational surface per signal.
* Resource efficiency matters.
* You want to have more control over the stack.
* You want Apache 2.0 across the stack.

## VictoriaStack vs ClickStack (ClickHouse + HyperDX)

[ClickStack](https://github.com/ClickHouse/ClickStack) stores all signals in ClickHouse and ships HyperDX as a
unified UI with Lucene-style search, SQL support, dashboards, alerting, and session replay.

**Key differences:**

* ClickStack is built on top of ClickHouse, a general-purpose analytical database.
  Putting all signals in it gives you SQL over everything. The trade-off: a general-purpose engine needs tuning
  for each workload (schemas, codecs, TTLs, merges). VictoriaStack databases apply those optimizations by design.
  There are no schemas to manage for metrics, logs, or traces.
* ClickStack has bundled HyperDX UI: one interface for everything.
  VictoriaStack's answer is [Grafana with all three datasources](http://docs.victoriametrics.com/victoria-stack/ui/#grafana)
  plus per-database [vmui](http://docs.victoriametrics.com/victoria-stack/ui/#vmui).
  That setup is more flexible, but it is not a single out-of-the-box solution.
* ClickStack deploys ClickHouse, HyperDX, MongoDB (for HyperDX metadata), and an OpenTelemetry
  Collector. VictoriaStack is three self-contained binaries with no external dependencies.
* ClickHouse-based metrics lack a PromQL-compatible engine. This gap matters if your team
  lives in the Prometheus ecosystem with existing dashboards, alerts, recording rules, and exporters.
  VictoriaMetrics is
  a [drop-in Prometheus remote_write target](https://docs.victoriametrics.com/victoriametrics/#prometheus-setup)
  with a PromQL-compatible query API.

**Prefer ClickStack when:**

* Your team prefers SQL.
* You want one UI with session replay for full-stack debugging.
* You already operate ClickHouse and have expertise in it.

**Prefer VictoriaStack when:**

* You come from the Prometheus/Grafana ecosystem and want your dashboards, alerts, and exporters to keep working.
* You want databases that need no schema design or engine tuning per signal.
* You want zero external dependencies.

## VictoriaStack vs SigNoz

[SigNoz](https://github.com/SigNoz/signoz) is an OpenTelemetry-native, APM-flavored all-in-one platform
(traces, logs, metrics, exceptions) built on ClickHouse, with its own UI, dashboards, and alerting.

**Key differences:**

* SigNoz optimizes for the **APM experience out of the box**: service maps, latency percentiles per endpoint,
  and exceptions. It is closer to a self-hosted Datadog than to a set of databases.
  VictoriaStack is optimized for building an observability platform with high flexibility and control options.
* SigNoz is built on top of ClickHouse, a general-purpose analytical database.
  Putting all signals in it gives you SQL over everything. The trade-off: a general-purpose engine needs tuning
  for each workload (schemas, codecs, TTLs, merges). VictoriaStack databases apply those optimizations by design.
  There are no schemas to manage for metrics, logs, or traces.
* SigNoz metrics support PromQL queries, but the primary interface is SigNoz's query builder.
  VictoriaMetrics is a more natural fit for the Prometheus ecosystem, especially for recording rules, remote_write from existing Prometheus fleets, and Grafana dashboards.
* Multitenancy is built into every VictoriaStack database. Self-hosted SigNoz is single-tenant, with multitenancy available in the Cloud offering.

**Prefer SigNoz when:** a small team wants a Datadog-like APM experience, self-hosted, with minimal composition work.

**Prefer VictoriaStack when:**

* You are building a platform for many teams and need multitenancy, access control, and per-tenant limits.
* You are migrating an existing Prometheus setup.
* You operate at a scale where per-signal efficiency dominates costs.

## VictoriaStack vs Elastic Stack

The Elastic Stack (Elasticsearch + Kibana) remains the most widely deployed log platform and also covers APM and
metrics.

**Key differences:**

* Elasticsearch builds full-text indexes over everything. Indexing gives unmatched search flexibility, but it costs
  significant RAM, CPU, and disk. VictoriaLogs indexes stream fields and runs fast full scans over compressed data
  for the rest. For observability log workloads, VictoriaLogs typically needs an order of magnitude less hardware
  (see the [VictoriaLogs vs Elasticsearch benchmarks](https://docs.victoriametrics.com/victorialogs/faq/#what-is-the-difference-between-victorialogs-and-elasticsearch-opensearch)).
* Metrics are not Elasticsearch's native workload. There is no PromQL support, and TSDB-style compression is newer
  and less space-efficient than dedicated time series databases.
* Elasticsearch offers three licenses (Elastic License 2.0, SSPL, and AGPLv3 since 2024). VictoriaStack is Apache 2.0.

**Prefer Elastic when:** search is your primary use case (security analytics, business documents, complex full-text
queries over logs), or you already run Elastic for search and want observability to piggyback on it.

**Prefer VictoriaStack when:** 
* You value cost-efficiency and flexibility. The savings could reach x30.
* You are migrating an existing Prometheus setup.
* You operate at a scale where per-signal efficiency dominates costs.

## VictoriaStack vs Prometheus + Thanos (and friends)

Many teams run Prometheus with [Thanos](https://thanos.io/) for long-term storage, plus a separate log and trace stack.
Prometheus is the standard VictoriaMetrics is compatible with, not an adversary. VictoriaMetrics accepts
[remote_write](https://docs.victoriametrics.com/victoriametrics/#prometheus-setup), serves a PromQL-compatible API,
and [vmagent](https://docs.victoriametrics.com/victoriametrics/vmagent/) supports the full Prometheus scrape config
and service discovery.

* **A healthy, stable Prometheus setup needs no migration.** If it fits in one node and works, keep it.
* Teams usually evaluate VictoriaMetrics when they hit scale pain: high cardinality, RAM pressure, slow queries over
  long retention, or the operational cost of Thanos components (sidecars, store gateways, compactors, object storage).
  VictoriaMetrics replaces that setup with a [simpler architecture]((https://docs.victoriametrics.com/victoriametrics/cluster-victoriametrics/)).
* Thanos transparently supports offloading of historical data to S3, which theoretically provides an infinitely scalable
  storage solution. However, storing and reading data from S3 is not free and comes with additional challenges.
* Prometheus and Thanos cover metrics only. Logs and traces still need a second and a third stack.
  VictoriaStack fills exactly that gap with a shared operational model.

## How to choose

| If                                                                                                         | Choose                                    |
|------------------------------------------------------------------------------------------------------------|-------------------------------------------|
| You live in the Prometheus/Grafana ecosystem and want logs and traces with the same operational simplicity | **VictoriaStack**                         |
| You need one bundled UI with session replay, and your team thinks in SQL                                   | **ClickStack**                            |
| You want a self-hosted, Datadog-like APM for one team                                                      | **SigNoz**                                |
| You require strict PromQL compatibility and native integration with Grafana                                | **Grafana LGTM**                          |
| You mostly focused on Logs search,  and cost efficiency is not a priority                                                 | **Elastic**                               |

> Found a mistake on this page, or a comparison dimension we should add?
> [Open an issue](https://github.com/VictoriaMetrics/VictoriaStack/issues). We welcome corrections and apply them.


