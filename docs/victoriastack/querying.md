---
title: Querying
menu:
  docs:
    weight: 3
    identifier: victoriastack-querying
    parent: victoriastack
tags:
  - metrics
  - logs
  - traces
---

Metrics, logs, and traces have different structures and query patterns. VictoriaStack uses signal-specific query
languages and integrations, so each database can optimize for the data it stores:

| Signal      | Query language                                                                   | API                                                                                                                                                                                                                    |
|-------------|----------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Metrics** | [MetricsQL](https://docs.victoriametrics.com/victoriametrics/metricsql/)          | [Prometheus querying API](https://docs.victoriametrics.com/victoriametrics/#prometheus-querying-api-usage), [Graphite API](https://docs.victoriametrics.com/victoriametrics/integrations/graphite/#graphite-api-usage) |
| **Logs**    | [LogsQL](https://docs.victoriametrics.com/victorialogs/logsql/)                   | [VictoriaLogs HTTP API](https://docs.victoriametrics.com/victorialogs/querying/#http-api)                                                                                                                              |
| **Traces**  | [LogsQL](https://docs.victoriametrics.com/victorialogs/logsql/)                   | [Jaeger API](https://docs.victoriametrics.com/victoriatraces/querying/#jaeger-http-api), [Tempo API](https://docs.victoriametrics.com/victoriatraces/querying/#tempo-http-api)                                         |

<br>

Two languages cover all three signals, since VictoriaTraces stores spans as wide events and queries them with LogsQL.
The same languages are used by [alerting and recording rules](http://localhost:1313/victoriastack/alerting/#rules), so a
query built in a UI can be turned into a rule as it is.

Queries run from [Grafana or Perses](http://localhost:1313/victoriastack/ui/#grafana), from the built-in
[vmui](http://localhost:1313/victoriastack/ui/#vmui), or from any HTTP client, see [Query APIs](#query-apis).

## Querying metrics

VictoriaMetrics query language [MetricsQL](https://docs.victoriametrics.com/victoriametrics/metricsql/) is inspired
by [PromQL](https://prometheus.io/docs/prometheus/latest/querying/basics/). MetricsQL is backward-compatible with PromQL,
so Grafana dashboards backed by a Prometheus datasource or alerting/recording rules should work the same after switching
from Prometheus to VictoriaMetrics. However, there are some [intentional differences](https://medium.com/@romanhavronenko/victoriametrics-promql-compliance-d4318203f51e)
between these two languages.

If you're not familiar with PromQL or MetricsQL, please read the basic concepts of [MetricsQL](https://docs.victoriametrics.com/victoriametrics/keyconcepts/#metricsql).

On top of PromQL, MetricsQL adds conveniences that shorten everyday queries:

* the lookbehind window in square brackets may be omitted, so `rate(requests_total)` is a valid query that auto-adjusts
  the lookbehind window based on the real interval between samples and query step;
* series selectors accept multiple `or` filters, such as `{env="prod",job="a" or env="dev",job="b"}`;
* MetricsQL doesn't extrapolate rate and increase function results. For example, it returns integer results from `increase()` over slow-changing integer counters;
* [`WITH` expressions](https://docs.victoriametrics.com/victoriametrics/metricsql/#with-expressions) extract repeating
  parts of a query into named templates.
* About 100+ additional functions are supported. See [MetricsQL functions](https://docs.victoriametrics.com/victoriametrics/metricsql/#metricsql-functions).

For example, the following query returns the request rate per route, and the one below it the 99th percentile of request
duration:

```metricsql
sum(rate({__name__="http.server.request.duration_count"})) by ("http.route")

histogram_quantile(0.99, sum(rate({__name__="http.server.request.duration_bucket"})) by (le, "http.route"))
```

Additionally, VictoriaMetrics implements [Graphite API](https://docs.victoriametrics.com/victoriametrics/integrations/graphite/#graphite-api-usage)
for querying, which makes it a drop-in replacement for Graphite.

> For querying experience, take a quick look at [vmui](https://docs.victoriametrics.com/playgrounds/#victoriametrics-playground)
> and [Grafana](https://docs.victoriametrics.com/playgrounds/#grafana-playground) playgrounds.

## Querying logs

VictoriaLogs query language [LogsQL](https://docs.victoriametrics.com/victorialogs/logsql/) is specifically designed for
querying logs and provides the following features:
* Full-text search in any field.
* Ability to combine filters into arbitrary complex [logical filters](https://docs.victoriametrics.com/victorialogs/logsql/#logical-filter).
* Ability to extract structured fields from unstructured logs at query time via [transformations](https://docs.victoriametrics.com/victorialogs/logsql/#transformations).
* Ability to calculate various stats over the selected log entries via [stats](https://docs.victoriametrics.com/victorialogs/logsql/#stats-pipe).

> LogsQL provides excellent analytical capabilities and participates in the [ClickBench - a benchmark for analytical databases](https://github.com/ClickHouse/ClickBench/tree/main/victorialogs).

A LogsQL query starts with filters and optionally pipes the selected logs into further processing. The simplest query 
would be to match all logs:

```logsql
*
```

Filters combine, and every field of a log entry can be filtered, including numeric comparisons. The following query
selects logs with word `quote` and where the `context.total` field exceeds 20:

```logsql
"quote" context.total:>20
```

Pipes allow delimiting actions applying them one by one:

```logsql
"quote" context.total:>20 | stats by (service.name, severity_text) count() as logs | sort by (logs)
```

To get the basic concepts of LogsQL, please read [LogsQL tutorial](https://docs.victoriametrics.com/victorialogs/logsql/#logsql-tutorial).

> For querying experience, take a quick look at [vmui](https://docs.victoriametrics.com/playgrounds/#victorialogs-playground)
> and [Grafana](https://docs.victoriametrics.com/playgrounds/#grafana-playground) playgrounds.

Coming from another log database? See [SQL to LogsQL](https://docs.victoriametrics.com/victorialogs/sql-to-logsql/) and
[How To Convert Loki Queries to VictoriaLogs Queries](https://docs.victoriametrics.com/victorialogs/logql-to-logsql/).

## Querying traces

VictoriaTraces stores spans as wide events, so it queries them
with [LogsQL](https://docs.victoriametrics.com/victorialogs/logsql/) as well. That makes filtering and analytics over
spans work the same way as over logs: filter by any field, extract fields at query time, and calculate stats over the
matching spans.

For reading traces, VictoriaTraces also serves [Jaeger](https://docs.victoriametrics.com/victoriatraces/querying/#jaeger-http-api)
and [Tempo](https://docs.victoriametrics.com/victoriatraces/querying/#tempo-http-api) compatible APIs. Explore traces
through [Grafana or Perses](http://localhost:1313/victoriastack/ui/#grafana) connected via these APIs: they render the
waterfall view of a trace, which no LogsQL query can replace. Use LogsQL for filtering, analysis,
and [alerting on traces](https://docs.victoriametrics.com/victoriatraces/vmalert/).

## Query APIs

Every database answers queries over HTTP, which is what the [UIs integrations](http://localhost:1313/victoriastack/ui/),
[alerting](http://localhost:1313/victoriastack/alerting/), and any script or exporter use:

* **Metrics**: [`/api/v1/query`, `/api/v1/query_range`](https://docs.victoriametrics.com/victoriametrics/#prometheus-querying-api-usage)
  and other handlers from Prometheus querying API. Additionally, see [Graphite API](https://docs.victoriametrics.com/victoriametrics/integrations/graphite/#graphite-api-usage).
* **Logs**: [`/select/logsql/query`](https://docs.victoriametrics.com/victorialogs/querying/#http-api) and other handlers
  from VictoriaLogs HTTP API, including tailing, statistics calculation, fileds exploration, etc. 
* **Traces**: the same LogsQL endpoints as for logs, plus the Jaeger and Tempo APIs.

Read requests select their [tenant](http://localhost:1313/victoriastack/multitenancy/#query-path) with the `AccountID`
and `ProjectID` HTTP headers, the same way in all three databases.
