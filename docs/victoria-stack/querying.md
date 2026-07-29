---
title: Querying
menu:
  docs:
    weight: 3
    identifier: victoria-stack-querying
    parent: victoria-stack
tags:
  - metrics
  - logs
  - traces
---

Metrics, logs, and traces have different structures and query patterns. VictoriaStack uses signal-specific query languages and integrations so each product can optimize for the data it stores.

## Querying metrics

VictoriaMetrics query language [MetricsQL](https://docs.victoriametrics.com/victoriametrics/metricsql/) is inspired
by [PromQL](https://prometheus.io/docs/prometheus/latest/querying/basics/). MetricsQL is backward-compatible with PromQL,
so Grafana dashboards backed by a Prometheus datasource or alerting/recording rules should work the same after switching
from Prometheus to VictoriaMetrics. However, there are some [intentional differences](https://medium.com/@romanhavronenko/victoriametrics-promql-compliance-d4318203f51e)
between these two languages.

If you're not familiar with PromQL or MetricsQL, please read the basic concepts of [MetricsQL](https://docs.victoriametrics.com/victoriametrics/keyconcepts/#metricsql).

Additionally, VictoriaMetrics implements [Graphite API](https://docs.victoriametrics.com/victoriametrics/integrations/graphite/#graphite-api-usage)
for querying, which makes it a drop-in replacement for Graphite.

> For querying experience, take a quick look at [vmui](https://docs.victoriametrics.com/playgrounds/#victoriametrics-playground)
> and [Grafana](https://docs.victoriametrics.com/playgrounds/#grafana-playground) playgrounds.

See [migrating from PromQL to MetricsQL].

## Querying logs

VictoriaLogs query language [LogsQL](https://docs.victoriametrics.com/victorialogs/logsql/) is specifically designed for
querying logs and provides the following features:
* Full-text search in any field.
* Ability to combine filters into arbitrary complex [logical filters](https://docs.victoriametrics.com/victorialogs/logsql/#logical-filter).
* Ability to extract structured fields from unstructured logs at query time via [transformations](https://docs.victoriametrics.com/victorialogs/logsql/#transformations).
* Ability to calculate various stats over the selected log entries via [stats](https://docs.victoriametrics.com/victorialogs/logsql/#stats-pipe).

> LogsQL provides excellent analytical capabilities and participates in the [ClickBench - a benchmark for analytical databases](https://github.com/ClickHouse/ClickBench/tree/main/victorialogs).

To get the basic concepts of LogsQL, please read [LogsQL tutorial](https://docs.victoriametrics.com/victorialogs/logsql/#logsql-tutorial).

> For querying experience, take a quick look at [vmui](https://docs.victoriametrics.com/playgrounds/#victorialogs-playground)
> and [Grafana](https://docs.victoriametrics.com/playgrounds/#grafana-playground) playgrounds.

See also [SQL to LogsQL Tutorial](https://docs.victoriametrics.com/victorialogs/sql-to-logsql/) and
[How To Convert Loki Queries to VictoriaLogs Queries](https://docs.victoriametrics.com/victorialogs/logql-to-logsql/).

## Querying traces

VictoriaTraces supports [LogsQL](https://docs.victoriametrics.com/victorialogs/logsql/) for direct querying and also exposes Jaeger and Tempo-compatible APIs. For interactive trace exploration, [Grafana] or [Perses] are often the most convenient UIs, while direct LogsQL queries remain useful for filtering, analysis, and [alerting with traces](https://docs.victoriametrics.com/victoriatraces/vmalert/).



