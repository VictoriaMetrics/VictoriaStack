---
title: UI integrations
menu:
  docs:
    weight: 2
    identifier: victoriastack-ui-integrations
    parent: victoriastack
tags:
  - metrics
  - logs
  - traces
---

## vmui

vmui is a UI frontend for VictoriaMetrics and VictoriaLogs. It is designed for ad-hoc exploration of metrics and logs,
using all the features of the corresponding database.

> VictoriaTraces doesn't have a dedicated UI yet, so it is recommended to use [Grafana](#) to explore traces.

vmui is built into the VictoriaMetrics and the VictoriaLogs components:
* [VictoriaMetrics UI](https://docs.victoriametrics.com/victoriametrics/#vmui)
* [VictoriaLogs UI](https://docs.victoriametrics.com/victorialogs/querying/#web-ui)

> Have a quick look at the vmui demo for [VictoriaMetrics](https://docs.victoriametrics.com/playgrounds/#victoriametrics-playground)
> and [VictoriaLogs](https://docs.victoriametrics.com/playgrounds/#victorialogs-playground) at our playgrounds.

We recommend using vmui for exploring metrics and logs when you value simplicity and speed.
Use [Grafana]() or [Perses]() for dashboard functionality.

## Grafana

Grafana is a great choice of a visualization tool that integrates with VictoriaStack.

The integration is happening via datasource plugins:
* VictoriaMetrics via the [Prometheus](https://docs.victoriametrics.com/victoriametrics/integrations/grafana/#prometheus-datasource) or the [VictoriaMetrics](https://docs.victoriametrics.com/victoriametrics/integrations/grafana/#victoriametrics-datasource) datasource plugins.
* VictoriaLogs via the [VictoriaLogs datasource plugin](https://docs.victoriametrics.com/victorialogs/integrations/grafana/).
* VictoriaTraces via the [Jaeger](https://docs.victoriametrics.com/victoriatraces/querying/grafana/#jaeger-datasource) or the [Tempo](https://docs.victoriametrics.com/victoriatraces/querying/grafana/#grafana-tempo-datasource) datasource plugins.

> See [Grafana integration examples]() for single-node and clustered VictoriaStack.

Grafana provides a queryless experience for exploring metrics, logs, and traces using the query builders within the datasource plugins.
It is the easiest way to get started reading data from VictoriaStack. But if you need advanced querying capabilities, see [querying docs]().

Grafana is also a great tool for building dashboards, running alerting rules, and [correlating signals]().

## Perses

Similarly to [Grafana](#grafana), Perses integrates with VictoriaStack via datasource plugins:
* VictoriaMetrics integrates via [Prometheus datasource plugin](https://docs.victoriametrics.com/victoriametrics/integrations/perses/).
* VictoriaLogs integrates via [VictoriaLogs datasource plugin](https://docs.victoriametrics.com/victorialogs/integrations/perses/).
* VictoriaTraces integrates via [Jaeger](https://github.com/perses/plugins/tree/main/jaeger) or [Tempo](https://docs.victoriametrics.com/victoriatraces/querying/grafana/#grafana-tempo-datasource) datasource plugins.

If you need advanced querying capabilities, see [querying docs]().

## Correlations

Signals can be correlated when they share common attributes that identify the same system or event.
The recommended user interface for correlations is Grafana thanks to its [correlation](https://grafana.com/docs/grafana/latest/administration/correlations/)
and derived fields features.

Depending on the Grafana datasource plugin, there could be multiple correlations available:
1. Trace to logs, log to trace, log to metrics - see [correlations via VictoriaLogs plugin](https://docs.victoriametrics.com/victorialogs/integrations/grafana/#correlations).
1. Trace to metrics, metric to logs, metric to traces - see [correlations via VictoriaMetrics plugin](https://docs.victoriametrics.com/victoriametrics/integrations/grafana/datasource/#correlations).
1. Metrics to logs or traces correlations are possible via the Prometheus datasource as well.
1. Plugins Tempo, Jaeger, and Zipkin can correlate with logs or metrics using [Trace to logs](https://grafana.com/docs/grafana/latest/explore/trace-integration/#trace-to-logs)
   and [Trace to metrics](https://grafana.com/docs/grafana/latest/visualizations/explore/trace-integration/#trace-to-metrics) feature.

Logs and Traces can be converted to metrics via [alerting and recording rules](), which opens further possibilities for correlation.


