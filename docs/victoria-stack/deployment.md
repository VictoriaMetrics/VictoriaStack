---
title: Deployment
menu:
  docs:
    weight: 1
    identifier: victoria-stack-deployment
    parent: victoria-stack
tags:
  - metrics
  - logs
  - traces
---

VictoriaStack consists of multiple components that can be deployed together or separately, in many different ways and
in different environments. Choose what suits your needs best.

## Local / Development

All VictoriaStack components are distributed as executable binaries that can be run on many supported platforms and
architectures. See Quick Start instructions for running in various environments each product's documentation:
- [VictoriaMetrics Quick Start](https://docs.victoriametrics.com/victoriametrics/quick-start/) (metrics)
- [VictoriaLogs Quick Start](https://docs.victoriametrics.com/victorialogs/quick-start/) (logs)
- [VictoriaTraces Quick Start](https://docs.victoriametrics.com/victoriatraces/quick-start/) (traces)
- [vmauth Quick Start](https://docs.victoriametrics.com/victoriametrics/vmauth/) (authentication, routing, load balancing)
- [vmalert Quick Start](https://docs.victoriametrics.com/victoriametrics/vmalert/#quickstart) (alerting)

### Binary

VictoriaStack components binaries can be downloaded from the GitHub releases page:
- [VictoriaMetrics](https://github.com/VictoriaMetrics/VictoriaMetrics/releases)
- [VictoriaLogs](https://github.com/VictoriaMetrics/VictoriaLogs/releases)
- [VictoriaTraces](https://github.com/VictoriaMetrics/VictoriaTraces/releases)

When downloading the archives with binaries, remember to choose architecture that matches your environment.
See detailed instructions on downloading and running binaries:
- [VictoriaMetrics](https://docs.victoriametrics.com/victoriametrics/quick-start/#try-it-locally)
- [VictoriaLogs](https://docs.victoriametrics.com/victorialogs/quickstart/#try-it-locally)
- VictoriaTraces
- https://docs.victoriametrics.com/victoriatraces/quick-start/#starting-victoriatraces-single-node-from-a-binary

On releases page youc

### Docker
### Docker Compose
## Kubernetes
### Helm Charts
### VictoriaMetrics Operator



## Helm Charts

VictoriaStack components can be deployed using [Helm charts](https://docs.victoriametrics.com/helm/).

## Kuberentes Operator

> More detailed 