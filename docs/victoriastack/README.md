**VictoriaStack** is a unified observability platform built with three specialized databases that share the same
design philosophy, operational model, and ecosystem:

| Signal      | Product                                                              | Query language                                                                                                                                                                                                                                  | Scalability                                                                     |
|-------------|----------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------|
| **Metrics** | [VictoriaMetrics](https://docs.victoriametrics.com/victoriametrics/) | [MetricsQL](https://docs.victoriametrics.com/metricsql/) (PromQL-compatible)                                                                                                                                                                    | Billions of [active time series](), Millions of [samples]() ingested per second |
| **Logs**    | [VictoriaLogs](https://docs.victoriametrics.com/victorialogs/)       | [LogsQL](https://docs.victoriametrics.com/victorialogs/logsql/)                                                                                                                                                                                 | Hundreds of TBs a day, with avg compression ratio of x10                        |
| **Traces**  | [VictoriaTraces](https://docs.victoriametrics.com/victoriatraces/)   | [LogsQL](https://docs.victoriametrics.com/victorialogs/logsql/), [Jaeger API](https://docs.victoriametrics.com/victoriatraces/querying/#jaeger-http-api), [Tempo API](https://docs.victoriametrics.com/victoriatraces/querying/#tempo-http-api) | Millions of traces ingested per second                                          |

//todo: update scalability numbers for traces and logs
<br>

All three solutions support the following features out-of-the-box:

- [Horizontal scaling]()
- [Multitenancy]()
- [Alerting]()
- [Grafana integration]()
- [OpenTelemetry](https://docs.victoriametrics.com/opentelemetry/) for ingestion
- Apache 2 licensed

## Why VictoriaStack?

VictoriaStack software is built on three core principles: **simplicity, reliability, and efficiency**.
It is easy to run and maintain, it fits well in home labs and can be reliably scaled to large production
environments. Each of the databases was heavily battle-tested in production environments.

The stack is focusing on what matters most for each signal. VictoriaMetrics is optimized
for time series workload, while VictoriaLogs design and architecture are optimized for log ingestion.
The separation of storage backends allows keeping solutions simple, efficient, independent, and fine-tuned for each
signal.

It is well integrated into the modern observability ecosystem by supporting various protocols for ingestion
and User Interfaces like Grafana and Perses for querying. It supports multitenancy, alerting, out-of-order backfilling,
efficient compression, sane defaults for simplified setup, wide community and support.

VictoriaStack is the best choice if you want to **own your observability stack**, build a **reliable**, **cost-effieicient
multitenant platform** ready for future growth.

## Architecture Overview

![readme-stack.webp](readme-stack.png)
{width="700"}

| What                                                                                    | How                                                                                                                                                                                                                                                                                |
|-----------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **[Deployment](http://localhost:1313/victoriastack/deployment/)**                       | [Kubernetes Operator](http://localhost:1313/victoriastack/deployment/#victoriametrics-operator), [Helm charts](http://localhost:1313/victoriastack/deployment/#helm-charts), [Binaries](http://localhost:1313/victoriastack/deployment/#binary)                                    |
| **[Ingestion integrations](http://localhost:1313/victoriastack/ingestion/)**            | [OpenTelemetry](http://localhost:1313/victoriastack/ingestion/#opentelemetry), [Vector](https://vector.dev/), [Grafana Alloy](https://grafana.com/docs/alloy/latest/), [10+ additional integrations](http://localhost:1313/victoriastack/ingestion/#integrations)                  |
| **[Native ingestion](http://localhost:1313/victoriastack/ingestion/#native-ingestion)** | **High troughput, reliable on-disk buffering, replication, traffic compression** via [vmagent](http://localhost:1313/victoriastack/ingestion/#vmagent) for metrics and [vlagent](http://localhost:1313/victoriastack/ingestion/#vlagent) for logs.                                 |
| **[Access control](http://localhost:1313/victoriastack/access-control/)**               | [vmauth](https://docs.victoriametrics.com/victoriametrics/vmauth/) for [user's authentication](http://localhost:1313/victoriastack/access-control/#authenticate-users), [requests routing](http://localhost:1313/victoriastack/access-control/#tenants-filtering), load balancing. |
| **[Visualization](http://localhost:1313/victoriastack/ui/)**                            | [Grafana](http://localhost:1313/victoriastack/ui/#grafana) and [Perses](http://localhost:1313/victoriastack/ui/#perses) for unified observability and dashboarding. Built-in [vmui](http://localhost:1313/victoriastack/ui/#vmui) for ad-hoc exploration.                          |
| **[Alerting](http://localhost:1313/victoriastack/alerting/)**                           | [vmalert](https://docs.victoriametrics.com/victoriametrics/vmalert/) integrated with [Alertmanager](http://localhost:1313/victoriastack/alerting/#alertmanager) for rules evaluation and dispatching notifications                                                                 |
| **[Anomaly detection]()**                                                               | [vmaonmaly]() ...                                                                                                                                                                                                                                                                  |
| **[Enterprise](), [Long Term Support(LTS) releases]()**                                 |                                                                                                                                                                                                                                                                                    |

// TODO: add links to stack components

## Quick Start

> If you're looking for a visual impression of the VictoriaStack,
> visit [Playgrounds page](https://docs.victoriametrics.com/playgrounds/)
> and try publicly running installations fed
> with [OpenTelemetry Astronomy Shop demo](https://github.com/open-telemetry/opentelemetry-demo) data.

VictoriaStack can be deployed on bare metal as binaries, as docker containers, using helm charts, or Kubernetes
operator.
See more detailed [deployment docs](http://localhost:1313/victoriastack/deployment/).

In the sections below, we'll go through examples of deploying VictoriaStack via docker compose to make it is
easy to run and experiment with locally.

### Single-node version

The simplest version of the stack would be to run VictoriaMetrics, VictoriaLogs and VictoriaTraces as single-node
deployments. To
run [the stack locally with docker compose](https://github.com/VictoriaMetrics/VictoriaStack/blob/main/deployment/otel-single-node-compose.yml)
use the following command:

```sh
git clone https://github.com/VictoriaMetrics/VictoriaStack.git && cd VictoriaStack
make otel-single-up
```

All manifests and configs that run this environment are available at [VictoriaStack/deployment](https://github.com/VictoriaMetrics/VictoriaStack/blob/main/deployment/otel-single-node-compose.yml).

> Note: the Docker Compose environment is very much simplified for demonstration purposes -
> it is **not intended for production use**.

The compose command will start:

- Generator of telemetry + OpenTelemetry collector;
- Single-node versions of VictoriaMetrics, VictoriaLogs, VictoriaTraces for storing and querying signals;
- vmalert for executing alerting rules;
- Grafana for visualizing signals;
- vmauth as a single entrypoint, that will authorize and route requests to the appropriate VictoriaStack component.

![readme-compose-single.webp](readme-compose-single.png)

Once running, the following links will be available:

- [VictoriaMetrics UI - http://localhost:8427/metrics/select/vmui](http://localhost:8427/metrics/select/vmui/?#/cardinality)
  ![readme-metrics-vmui-demo.webp](readme-metrics-vmui-demo.png)
  {width="500"}
- [VictoriaLogs UI - http://localhost:8427/logs/select/vmui](http://localhost:8427/logs/select/vmui)
  ![readme-logs-vmui-demo.webp](readme-logs-vmui-demo.png)
  {width="500"}
- [VictoriaTraces UI - http://localhost:8427/traces/select/vmui](http://localhost:8427/traces/select/vmui), but it is
  better to
  use [Grafana](http://localhost:3000)
- [Grafana - http://localhost:3000](http://localhost:3000/explore) with preconfigured datasources
  and a simple demo dashboard (_login with admin:admin_).
  ![readme-grafana-demo.webp](readme-grafana-demo.png)
  {width="500"}

While running, the generator will continue pushing telemetry signals via OpenTelemetry collector to the stack, and
vmalert will execute alerting rules. To stop the stack, run the following command:

```sh
make otel-single-down
```

The single-node version of the stack is the best and simplest to start with, experiment and learn how components are
interconnected. To see how to scale stack horizontally - see the [clustered version](#clustered-version) of the stack.

### Clustered version

To start
the [clustered version of the stack](https://github.com/VictoriaMetrics/VictoriaStack/blob/main/deployment/otel-cluster-compose.yml)
run the following command:

```sh
git clone https://github.com/VictoriaMetrics/VictoriaStack.git && cd VictoriaStack
make otel-cluster-up
```

All manifests and configs that run this environment are available at [VictoriaStack/deployment](https://github.com/VictoriaMetrics/VictoriaStack/blob/main/deployment/otel-single-node-compose.yml).

It runs the same setup as the [single-node version](#single-node-version), but each database is deployed in a clustered
version, represented by three independently scalable types of components: insert, select and storage.
In this topology, vmauth also balances requests among insert and select components.

![readme-compose-cluster.webp](readme-compose-cluster.png)

Once running, the links remain the same as for single-node deployment - all thanks to vmauth handling the routing:

- [VictoriaMetrics UI - http://localhost:8427/metrics/select/vmui](http://localhost:8427/metrics/select/vmui/?#/cardinality)
- [VictoriaLogs UI - http://localhost:8427/logs/select/vmui](http://localhost:8427/logs/select/vmui)
- [VictoriaTraces UI - http://localhost:8427/traces/select/vmui](http://localhost:8427/traces/select/vmui), but it is
  better to
  use [Grafana](http://localhost:3000)
- [Grafana - http://localhost:3000](http://localhost:3000/explore) with preconfigured datasources
  and a simple demo dashboard (_login with admin:admin_).

From now on, scaling the stack is as simple as changing the number of replicas for the components. No additional
caches, compactors, or other components are required. See more about [cluster scalability](http://localhost:1313/victoriastack/deployment/#scalability).

## Deployment

For more options to deploy VictoriaStack in various environments see [deployment docs](http://localhost:1313/victoriastack/deployment/).

