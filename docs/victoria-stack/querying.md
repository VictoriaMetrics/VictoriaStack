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

Metrics, logs and traces aren't alike. They are all different types of data with different querying patterns.
Expressing these specifics within one query language would inevitably result into losing practicality and flexibility.
That's why each database in the stack has its own query languages and integrations, tailored to the type of the signal.

## Querying metrics

VictoriaMetrics query language [MetricsQL](https://docs.victoriametrics.com/victoriametrics/metricsql/) is inspired
by [PromQL](https://prometheus.io/docs/prometheus/latest/querying/basics/). MetricsQL is backwards-compatible with PromQL,
so Grafana dashboards backed by Prometheus datasource or alerting/recording rules should work the same after switching
from Prometheus to VictoriaMetrics. However, there are some [intentional differences](https://medium.com/@romanhavronenko/victoriametrics-promql-compliance-d4318203f51e)
between these two languages.

If you're not familiar with PromQL or MetricsQL, please read basic concepts of [MetricsQL](https://docs.victoriametrics.com/victoriametrics/keyconcepts/#metricsql).

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

To get the basic concepts of LogsQL please read [LogsQL tutorial](https://docs.victoriametrics.com/victorialogs/logsql/#logsql-tutorial).

> For querying experience, take a quick look at [vmui](https://docs.victoriametrics.com/playgrounds/#victorialogs-playground)
> and [Grafana](https://docs.victoriametrics.com/playgrounds/#grafana-playground) playgrounds.

See also [SQL to LogsQL Tutorial](https://docs.victoriametrics.com/victorialogs/sql-to-logsql/) and
[How To Convert Loki Queries to VictoriaLogs Queries](https://docs.victoriametrics.com/victorialogs/logql-to-logsql/).

## Querying traces

VictoriaTraces query language is the same as for VictoriaLogs: [LogsQL](https://docs.victoriametrics.com/victorialogs/logsql/).
But most of the tracing experience comes from the User Interface capabilities where traces are filtered and visualized
in queryless fashion. This is why it is better to use [Grafana] or [Perses] for exploring traces.

However, querying capabilites with LogsQL are still available and are especially useful for [alerting with traces](https://docs.victoriametrics.com/victoriatraces/vmalert/).
