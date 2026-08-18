---
title: Comparisons
menu:
  docs:
    weight: 7
    identifier: victoriastack-comparisons
    parent: victoriastack
tags:
  - metrics
  - logs
  - traces
---

This page compares VictoriaStack with the most popular alternatives, so you can pick the right tool
for your requirements.

**How to read this comparison.** VictoriaMetrics maintainers wrote this page, so bias is possible despite our
best efforts. We only make claims we can back with sources, and we list the cases where competitors are a better fit.
If you find an outdated or wrong statement,
please [open an issue](https://github.com/VictoriaMetrics/VictoriaStack/issues).

> Verify performance claims on **your** workload: we provide links to our benchmarks for reference.

## Design philosophies

Open-source observability stacks follow one of two architectural philosophies:

1. **A specialized database per signal** (*VictoriaStack, Grafana LGTM*).
   Each signal (metrics, logs, traces) gets a database optimized for its access patterns, accessed via a unified UI (Grafana, Perses).
   This gives the highest efficiency and flexibility, since every signal is processed through its own optimized pipeline and
   can be scaled independently.
2. **One general-purpose database for all signals** (*ClickStack, SigNoz, Elastic Stack*).
   All signals land in a single analytical database with a bundled UI on top. You get maximum query flexibility using the
   same query language for all signals. The cost is running a general-purpose database, not specialized for any single signal in particular.

**Neither philosophy is universally better.** The rest of this page explains the practical consequences.

## At a glance

|                             | **VictoriaStack**                                                                                                                                                            | **Grafana LGTM**                         | **ClickStack**                                                                                                                                                 | **SigNoz**                                                                                 | **Elastic Stack**                                                                           |
|-----------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------|
| **Signals**                 | Metrics, logs, traces                                                                                                                                                        | Metrics, logs, traces                    | Metrics, logs, traces                                                                                                                                          | Metrics, logs, traces                                                                      | Metrics, logs, traces                                                                       |
| **License**                 | [Apache 2.0](https://github.com/VictoriaMetrics/VictoriaMetrics/blob/master/LICENSE)                                                                                         | [AGPLv3](https://grafana.com/licensing/) | [ClickHouse: Apache 2.0](https://github.com/ClickHouse/ClickHouse/blob/master/LICENSE), [HyperDX: MIT](https://github.com/hyperdxio/hyperdx/blob/main/LICENSE) | [Apache 2, separate license for `ee/`](https://github.com/SigNoz/signoz/blob/main/LICENSE) | [Elastic License 2.0](https://www.elastic.co/pricing/faq/licensing#what-is-elastic-license) |
| **Query languages**         | [MetricsQL](https://docs.victoriametrics.com/victoriametrics/metricsql/) (PromQL-compatible), [LogsQL](https://docs.victoriametrics.com/victorialogs/logsql/) (logs, traces) | PromQL, LogQL, TraceQL                   | SQL, Lucene-style search                                                                                                                                       | PromQL, SQL                                                                                | ES QL, KQL, Lucene                                                                          |
| **OpenTelemetry ingestion** | Yes                                                                                                                                                                          | Yes                                      | Yes                                                                                                                                                            | Yes                                                                                        | Yes                                                                                         |
| **Horizontal scalability**  | Yes                                                                                                                                                                          | Yes                                      | Yes                                                                                                                                                            | Yes                                                                                        | Yes                                                                                         |
| **Multitenancy**            | Via labels or HTTP headers                                                                                                                                                   | Via HTTP headers                         | Via ClickHouse databases/RBAC                                                                                                                                  | Single-tenant self-hosted, via organizations in Cloud                                      | Via Spaces/RBAC                                                                             |
| **Bundled UI**              | Grafana, Perses, vmui                                                                                                                                                        | Grafana, Perses                          | HyperDX                                                                                                                                                        | SigNoz UI                                                                                  | Kibana                                                                                      |
| **Kubernetes**              | [Operator](https://docs.victoriametrics.com/operator/) + [Helm charts](https://docs.victoriametrics.com/helm/) covering the full stack                                       | Helm charts, Grafana Operator            | Helm charts                                                                                                                                                    | Helm charts                                                                                | ECK operator                                                                                |

## VictoriaStack vs Grafana LGTM

The LGTM stack is the closest by design to VictoriaStack. Both stacks use specialized databases for each signal,
and both use Grafana as the primary visualization UI.

**Key differences:**

* **Operational model.** LGTM components scale by splitting work across microservice roles: distributor, ingester,
  querier, compactor, and others. Compared to VictoriaStack, this requires more services to run and manage.
* **Resource usage.** VictoriaMetrics and VictoriaLogs typically need less RAM and CPU than Mimir and Loki on the same workload.
  See the published benchmarks comparing [VictoriaMetrics and Mimir (2022)](https://victoriametrics.com/blog/mimir-benchmark/)
  and [Why VictoriaLogs is a better alternative to Loki (2025)](https://itnext.io/why-victorialogs-is-a-better-alternative-to-grafana-loki-7e941567c4d5),
  as well as third-party reports such as [TrueFoundry's VictoriaLogs vs Loki (2026)](https://www.truefoundry.com/blog/victorialogs-vs-loki).
* **Storage.** The LGTM stack natively supports S3 for historical data: it keeps recent data on the local file system and
  uploads historical data to S3. VictoriaStack keeps all data on the local file system and uses S3 for backups only.
  There is ongoing work to [support S3 for historical data](https://github.com/VictoriaMetrics/VictoriaLogs/issues/48) in VictoriaStack.
* **Query languages.** Mimir, Loki, and Tempo use PromQL, LogQL, and TraceQL.
  VictoriaStack uses [MetricsQL](https://docs.victoriametrics.com/victoriametrics/metricsql/)
  and [LogsQL](https://docs.victoriametrics.com/victorialogs/logsql/).
  MetricsQL is a PromQL superset with
  [documented intentional differences](https://medium.com/@romanhavronenko/victoriametrics-promql-compliance-d4318203f51e).
  LogsQL queries both logs and traces and is designed to provide extensive analytical capabilities.
* **Grafana integration.** The LGTM stack is developed by Grafana Labs and integrates naturally with Grafana.
  VictoriaStack uses the native Prometheus datasource for metrics, and the Tempo or Jaeger datasources for traces. For
  logs, the VictoriaMetrics team develops and publishes its own Grafana datasource. Grafana treats it as a third-party
  plugin, so it doesn't support some features, such as Grafana Drilldown.
* **License.** LGTM projects use the AGPLv3 license. VictoriaStack uses Apache 2.0.
  For most end users there is no practical difference between the licenses.
  For teams that embed the databases into distributed products, Apache 2.0 is simpler to adopt.

**Prefer LGTM when:**

* You require strict PromQL compatibility.
* Your organization already invests heavily in Grafana Cloud tooling.

**Prefer VictoriaStack when:**

* Cost-efficiency matters.
* You host the observability stack on your own infrastructure.
* You want Apache 2.0 across the stack.

## VictoriaStack vs ClickStack

[ClickStack](https://github.com/ClickHouse/ClickStack) stores all signals in ClickHouse and ships HyperDX as a
unified UI with Lucene-style search, SQL support, dashboards, alerting, and session replay.

**Key differences:**

* ClickStack is built on top of [ClickHouse](https://github.com/ClickHouse/ClickHouse), a general-purpose analytical database.
  All signals are stored in the same installation and can be queried via SQL. The trade-off: a general-purpose database
  needs tuning for each workload (schemas, codecs, TTLs, merges). VictoriaStack databases apply those optimizations by design,
  so there are no schemas to manage for metrics, logs, or traces. There are no public benchmarks comparing the performance
  of ClickStack and VictoriaStack.
* ClickStack bundles the HyperDX UI: one interface for everything.
  VictoriaStack relies on [Grafana or Perses](http://localhost:1313/victoriastack/ui/),
  plus per-database [vmui](http://localhost:1313/victoriastack/ui/#vmui).
* ClickStack deploys ClickHouse, HyperDX, MongoDB for HyperDX metadata, and ZooKeeper or ClickHouse Keeper for coordination.
  VictoriaStack databases have no external dependencies, caches, or coordination services.
  In the cluster version, each database consists of three types of components: insert, select, and storage.
* ClickHouse-based metrics lack a PromQL-compatible engine, while VictoriaMetrics is
  a [drop-in Prometheus remote_write target](https://docs.victoriametrics.com/victoriametrics/#prometheus-setup)
  with a PromQL-compatible query API, alerting, scraping, and service discovery.
* ClickStack relies on OTLP for ingestion. VictoriaStack accepts OTLP as well, and additionally supports many other
  ingestion protocols and integrations with existing exporters, telemetry agents, and observability tools.

**Prefer ClickStack when:**

* Your team prefers SQL.
* You already operate ClickHouse and have expertise in it.

**Prefer VictoriaStack when:**

* You come from the Prometheus/Grafana ecosystem and want your dashboards, alerts, and exporters to keep working.
* You need ingestion pipelines other than OTLP.
* You want databases that need no schema design or engine tuning per signal.

## VictoriaStack vs SigNoz

[SigNoz](https://github.com/SigNoz/signoz) is an OpenTelemetry-native, APM-flavored all-in-one platform
(traces, logs, metrics, exceptions) built on ClickHouse, with its own UI, dashboards, and alerting.

**Key differences:**

* SigNoz optimizes for the **APM experience out of the box**: service maps, latency percentiles per endpoint,
  and exceptions. It is closer to a self-hosted Datadog than to a set of databases.
  VictoriaStack is optimized for building an observability platform with high flexibility and control options.
* SigNoz is built on top of ClickHouse and shares the [same trade-offs as ClickStack](#victoriastack-vs-clickstack).
* SigNoz metrics support PromQL queries, but the primary interface is SigNoz's query builder.
  VictoriaMetrics is a more natural fit for the Prometheus ecosystem, especially for recording rules and Grafana dashboards.
* Multitenancy is built into every VictoriaStack database. Self-hosted SigNoz is single-tenant, with multitenancy available in the Cloud offering.

**Prefer SigNoz when:** a small team wants a Datadog-like APM experience, self-hosted, with minimal composition work.

**Prefer VictoriaStack when:**

* You are building a platform for many teams and need multitenancy, access control, and per-tenant limits.
* You come from the Prometheus/Grafana ecosystem and want your dashboards, alerts, and exporters to keep working.
* You operate at a scale where per-signal efficiency dominates costs.

## VictoriaStack vs Elastic Stack

The Elastic Stack (Elasticsearch + Kibana) remains the most widely deployed log platform and also covers APM and
metrics.

**Key differences:**

* Elasticsearch builds full-text indexes over everything. Indexing gives unmatched search flexibility, but it costs
  significant RAM, CPU, and disk. VictoriaLogs indexes stream fields and runs fast full scans over compressed data
  for the rest. For observability log workloads, VictoriaLogs typically [needs an order of magnitude less hardware](https://itnext.io/how-do-open-source-solutions-for-logs-work-elasticsearch-loki-and-victorialogs-9f7097ecbc2f).
  See [What is the difference between VictoriaLogs and Elasticsearch?](https://docs.victoriametrics.com/victorialogs/faq/#what-is-the-difference-between-victorialogs-and-elasticsearch-opensearch).
* Metrics are not Elasticsearch's native workload. There is no PromQL support, and TSDB-style compression is newer
  and less space-efficient than dedicated time series databases.
* Elasticsearch offers three licenses (Elastic License 2.0, SSPL, and AGPLv3 since 2024). VictoriaStack is Apache 2.0.

**Prefer Elastic when:** search is your primary use case (security analytics, business documents, complex full-text
queries over logs), or you already run Elastic for search and want observability to piggyback on it.

**Prefer VictoriaStack when:**
* You value cost-efficiency and flexibility. The savings could reach x30.
* You are migrating an existing Prometheus setup.
* You operate at a scale where per-signal efficiency dominates costs.

## VictoriaStack vs Prometheus + Thanos

Many teams run Prometheus with [Thanos](https://thanos.io/) for long-term storage, plus a separate log and trace stack.
Prometheus is the standard VictoriaMetrics is compatible with: it accepts
[remote_write](https://docs.victoriametrics.com/victoriametrics/#prometheus-setup) data, serves a PromQL-compatible API,
and supports the Prometheus service discovery, scrape, and rules configuration formats.

* **A healthy, stable Prometheus setup needs no migration.** If it fits in one node and works, keep it.
* Teams usually evaluate VictoriaMetrics when they hit scale pain: high cardinality, RAM pressure, slow queries over
  long retention, or the operational cost of Thanos components (sidecars, store gateways, compactors, object storage).
  VictoriaMetrics replaces this setup with a [simpler architecture](https://docs.victoriametrics.com/victoriametrics/cluster-victoriametrics/).
* Thanos transparently offloads historical data to S3, which in theory provides infinitely scalable storage. However,
  storing and reading data in S3 is not free and comes with additional challenges.
* Prometheus and Thanos cover metrics only. Logs and traces still need a second and a third stack.
  VictoriaStack fills exactly that gap with a shared operational model.

## How to choose

| If                                                                                                         | Choose            |
|------------------------------------------------------------------------------------------------------------|-------------------|
| You live in the Prometheus/Grafana ecosystem and want logs and traces with the same operational simplicity | **VictoriaStack** |
| You need one bundled UI with session replay, and your team thinks in SQL                                   | **ClickStack**    |
| You want a self-hosted, Datadog-like APM for one team                                                      | **SigNoz**        |
| You require strict PromQL compatibility and native integration with Grafana                                | **Grafana LGTM**  |
| You are mostly focused on log search, and cost efficiency is not a priority                                | **Elastic**       |

> Found a mistake on this page, or a comparison dimension we should add?
> [Open an issue](https://github.com/VictoriaMetrics/VictoriaStack/issues). We welcome corrections and apply them.


