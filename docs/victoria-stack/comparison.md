This page compares VictoriaStack honestly with the most popular alternatives, so you can pick the right tool for your
requirements.

> **How to read this comparison.** VictoriaMetrics maintainers wrote this page, so bias is possible despite our
> best efforts. We only make claims we can link to sources for, and we list the cases where competitors are a better fit.
> If you find an outdated or wrong statement,
> please [open an issue](https://github.com/VictoriaMetrics/VictoriaStack/issues).
> Verify performance claims on **your** workload: all benchmarks below are linked.

## Design philosophies

Open-source observability stacks follow one of two architectural philosophies:

1. **A specialized database per signal** (*VictoriaStack, Grafana LGTM*).
   Each signal (metrics, logs, traces) gets a database optimized for its access patterns.
   The stacks differ in how you operate them: VictoriaStack databases share one deployment model,
   configuration style, and ecosystem toolset
   ([vmauth](https://docs.victoriametrics.com/victoriametrics/vmauth/), [vmagent](https://docs.victoriametrics.com/victoriametrics/vmagent/),
   [operator](https://docs.victoriametrics.com/operator/)), while LGTM projects scale through
   independent microservice roles and are unified by Grafana as the UI.
2. **One general-purpose database for all signals** (*ClickStack, SigNoz, Elastic Stack*).
   All signals land in a single analytical database with a bundled UI on top. You get maximum query flexibility,
   often in SQL. The cost is running a general-purpose database that is not specialized for any single signal.

Neither philosophy is universally better. The rest of this page explains the practical consequences.

## At a glance

|                          | **VictoriaStack**                                                                                                                                             | **Grafana LGTM**                             | **ClickStack**                                              | **SigNoz**                                       | **Elastic Stack**                   |
|--------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------|-------------------------------------------------------------|--------------------------------------------------|-------------------------------------|
| Signals                  | Metrics, logs, traces                                                                                                                                         | Metrics, logs, traces                        | Logs, traces, metrics, session replay                       | Traces, logs, metrics, exceptions                | Logs, traces, metrics               |
| License                  | [Apache 2.0](https://github.com/VictoriaMetrics/VictoriaMetrics/blob/master/LICENSE)                                                                          | [AGPLv3](https://grafana.com/licensing/)     | ClickHouse: Apache 2.0, HyperDX: MIT                        | MIT core, separate license for `ee/`             | Elastic License 2.0 / SSPL / AGPLv3 |
| External dependencies    | None                                                                                                                                                          | Object storage; memcached recommended        | MongoDB, OpenTelemetry Collector                            | OpenTelemetry Collector                          | JVM                                 |
| Minimal deployment       | 3 single binaries (1 per signal)                                                                                                                              | Monolithic mode per project + object storage | Docker compose (ClickHouse + HyperDX + MongoDB + collector) | Docker compose (SigNoz + ClickHouse + collector) | Elasticsearch + Kibana + collector  |
| Query languages          | [MetricsQL](https://docs.victoriametrics.com/victoriametrics/metricsql/) (PromQL-compatible), [LogsQL](https://docs.victoriametrics.com/victorialogs/logsql/) | PromQL, LogQL, TraceQL                       | SQL, Lucene-style search                                    | Query builder, PromQL, ClickHouse SQL            | ES QL, KQL, Lucene                  |
| OpenTelemetry ingestion  | [Native OTLP for all three signals](https://docs.victoriametrics.com/opentelemetry/)                                                                          | Native OTLP                                  | Native OTLP (OTel-first)                                    | Native OTLP (OTel-first)                         | Native OTLP                         |
| Prometheus compatibility | remote_write, PromQL-compatible API, scraping via [vmagent](https://docs.victoriametrics.com/victoriametrics/vmagent/)                                        | remote_write (Mimir)                         | Via collector                                               | Via collector                                    | Via collector                       |
| Trace query APIs         | [Jaeger and Tempo APIs](https://docs.victoriametrics.com/victoriatraces/querying/)                                                                            | Tempo API                                    | HyperDX UI, SQL                                             | SigNoz UI                                        | Kibana APM                          |
| Bundled UI               | [vmui](https://docs.victoriametrics.com/victoriametrics/#vmui) per database; Grafana recommended for dashboards and correlation                               | Grafana                                      | HyperDX (unified)                                           | SigNoz UI (unified)                              | Kibana (unified)                    |
| Multitenancy             | [Built-in for all three databases](https://docs.victoriametrics.com/victoriametrics/cluster-victoriametrics/#multitenancy)                                    | Built-in                                     | Via ClickHouse databases/RBAC                               | Single-tenant (self-hosted)                      | Via Spaces/RBAC                     |
| Kubernetes               | [Operator](https://docs.victoriametrics.com/operator/) + [Helm charts](https://docs.victoriametrics.com/helm/) covering the full stack                        | Helm charts, Grafana Operator                | Helm charts                                                 | Helm charts                                      | ECK operator                        |

## VictoriaStack vs Grafana LGTM (Mimir + Loki + Tempo)

The LGTM stack is the closest architectural relative of VictoriaStack. Both use specialized databases per signal,
and both use Grafana as the primary visualization layer.

**Key differences:**

* **Operational model.** LGTM components scale by splitting work across microservice roles: distributor, ingester,
  querier, compactor, and others. This design scales far. It also adds more parts to configure, monitor, and upgrade.
  VictoriaStack databases run as single binaries.
  [Cluster versions](https://docs.victoriametrics.com/victoriametrics/cluster-victoriametrics/) use three simple roles.
  That means fewer components to operate.
* **Resource usage.** VictoriaMetrics typically needs less RAM and CPU than Mimir on the same workload.
  See the [published benchmarks](https://victoriametrics.com/blog/mimir-benchmark/) from 2022.
  Since then, both Mimir and VictoriaMetrics have gone through many changes, so it is recommended to benchmark on your own workload.
  For logs, see
  the [VictoriaLogs vs Loki benchmarks](https://docs.victoriametrics.com/victorialogs/faq/#how-does-victorialogs-compare-to-loki)
  and third-party reports such
  as [TrueFoundry's migration from Loki](https://www.truefoundry.com/blog/victorialogs-vs-loki).
* **Query languages.** Mimir, Loki, and Tempo use PromQL, LogQL, and TraceQL.
  VictoriaStack uses [MetricsQL](https://docs.victoriametrics.com/victoriametrics/metricsql/)
  and [LogsQL](https://docs.victoriametrics.com/victorialogs/logsql/).
  MetricsQL is a PromQL superset with
  [documented intentional differences](https://medium.com/@romanhavronenko/victoriametrics-promql-compliance-d4318203f51e).
  LogsQL queries both logs and traces.
* **Grafana integration.** LGTM stack is developed by Grafana Labs and has better integration with Grafana interfaces.
  Third-party integrations via datasource plugins are simply not allowed to have access to the full Grafana ecosystem.
* **License.** LGTM projects use the AGPLv3 license. VictoriaStack uses Apache 2.0.
  For most end users this difference changes nothing. For teams that embed the databases into distributed products,
  Apache 2.0 is simpler to adopt.

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
unified UI with Lucene-style search, SQL, dashboards, alerting, and session replay.

**Key differences:**

* **One database vs specialized databases.** ClickHouse is great general-purpose analytical database.
  Putting all signals in it gives you SQL over everything. The trade-off: a general-purpose engine needs tuning
  for each workload (schemas, codecs, TTLs, merges). VictoriaStack databases apply those optimizations by design.
  There are no schemas to manage for metrics or logs.
* **Unified UI vs Grafana.** ClickStack has bundled HyperDX UI: one interface for everything,
  including session replay, which VictoriaStack does not offer. VictoriaStack's answer is
  [Grafana with all three datasources](https://docs.victoriametrics.com/victoriametrics/integrations/grafana/)
  plus per-database [vmui](https://docs.victoriametrics.com/victoriametrics/#vmui).
  This setup is more flexible, but Grafana is an extra component, not a single out-of-the-box experience.
* **Dependencies.** ClickStack deploys ClickHouse, HyperDX, MongoDB (for HyperDX metadata), and an OpenTelemetry
  Collector. VictoriaStack is three self-contained binaries with no external dependencies.
* **Metrics maturity.** ClickHouse-based metrics lack a PromQL-compatible engine. This gap matters if your team
  lives in the Prometheus ecosystem with existing dashboards, alerts, recording rules, and exporters.
  VictoriaMetrics is
  a [drop-in Prometheus remote_write target](https://docs.victoriametrics.com/victoriametrics/#prometheus-setup)
  with a PromQL-compatible query API.

**Prefer ClickStack when:**

* Your team thinks in SQL.
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
  VictoriaStack optimizes for reliable, efficient **infrastructure** that you compose your platform from.
* Under the hood, SigNoz runs ClickHouse. The general-purpose-database trade-offs from the ClickStack section apply.
* SigNoz metrics support PromQL queries, but the primary interface is SigNoz's query builder.
  The Prometheus ecosystem (recording rules, remote_write from existing Prometheus fleets, Grafana dashboards)
  is more natural with VictoriaMetrics.
* Multitenancy is built into every VictoriaStack database. Self-hosted SigNoz is single-tenant. !!!

**Prefer SigNoz when:** a small team wants a Datadog-like APM experience, self-hosted, with minimal composition work.

**Prefer VictoriaStack when:**

* You are building a platform for many teams and need multitenancy, access control via
  [vmauth](https://docs.victoriametrics.com/victoriametrics/vmauth/), and per-tenant retention.
* You are migrating an existing Prometheus estate.
* You operate at a scale where per-signal efficiency dominates costs.

## VictoriaStack vs Elastic Stack

The Elastic Stack (Elasticsearch + Kibana) remains the most widely deployed log platform and also covers APM and
metrics.

**Key differences:**

* Elasticsearch builds full-text indexes over everything. Indexing gives unmatched search flexibility, but it costs
  significant RAM, CPU, and disk. VictoriaLogs indexes stream fields and runs fast full scans over compressed data
  for the rest. For observability log workloads, VictoriaLogs typically needs an order of magnitude less hardware
  (see
  the [VictoriaLogs vs Elasticsearch benchmarks](https://docs.victoriametrics.com/victorialogs/faq/#how-does-victorialogs-compare-to-elasticsearch)).
* Metrics are not Elasticsearch's native workload. There is no PromQL support, and TSDB-style compression is newer
  and less space-efficient than dedicated time series databases.
* Elasticsearch offers three licenses (Elastic License 2.0, SSPL, and AGPLv3 since 2024). VictoriaStack is Apache 2.0.

**Prefer Elastic when:** search is your primary use case (security analytics, business documents, complex full-text
queries over logs), or you already run Elastic for search and want observability to piggyback on it.

**Prefer VictoriaStack when:** logs serve observability (troubleshooting, dashboards, alerting) rather than
document search, and hardware efficiency matters.

## VictoriaStack vs Prometheus + Thanos (and friends)

Many teams run Prometheus with [Thanos](https://thanos.io/) for long-term storage, plus a separate log and trace stack.
Prometheus is the standard we are compatible with, not an adversary. VictoriaMetrics accepts
[remote_write](https://docs.victoriametrics.com/victoriametrics/#prometheus-setup), serves a PromQL-compatible API,
and [vmagent](https://docs.victoriametrics.com/victoriametrics/vmagent/) supports the full Prometheus scrape config.

* **A healthy, stable Prometheus setup needs no migration.** If it fits in one node and works, keep it.
* Teams usually evaluate VictoriaMetrics when they hit scale pain: high cardinality, RAM pressure, slow queries over
  long retention, or the operational cost of Thanos components (sidecars, store gateways, compactors, object storage).
  VictoriaMetrics replaces that setup with a single binary or a
  [three-role cluster](https://docs.victoriametrics.com/victoriametrics/cluster-victoriametrics/).
  The cost is bit-for-bit PromQL semantics
  ([differences documented here](https://docs.victoriametrics.com/victoriametrics/metricsql/#metricsql-vs-promql)).
* Prometheus and Thanos cover metrics only. Logs and traces still need a second and a third stack.
  VictoriaStack fills exactly that gap with a shared operational model.

## How to choose

| If                                                                                                         | Choose                                    |
|------------------------------------------------------------------------------------------------------------|-------------------------------------------|
| You live in the Prometheus/Grafana ecosystem and want logs and traces with the same operational simplicity | **VictoriaStack**                         |
| You need one bundled UI with session replay, and your team thinks in SQL                                   | **ClickStack**                            |
| You want a self-hosted, Datadog-like APM for one team                                                      | **SigNoz**                                |
| You require strict PromQL, LogQL, or TraceQL compatibility                                                 | **Grafana LGTM**                          |
| Search is the product                                                                                      | **Elastic**                               |
| Your single-node Prometheus is healthy                                                                     | **Keep it.** We'll be here when it isn't. |

> Found a mistake on this page, or a comparison dimension we should add?
> [Open an issue](https://github.com/VictoriaMetrics/VictoriaStack/issues). We welcome corrections and apply them.
