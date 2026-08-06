---
title: Enterprise
menu:
  docs:
    weight: 8
    identifier: victoriastack-enterprise
    parent: victoriastack
tags:
  - metrics
  - logs
  - traces
---

Every component of VictoriaStack comes in two editions: the Apache 2 licensed community edition, and
the [Enterprise edition](https://docs.victoriametrics.com/victoriametrics/enterprise/) that adds features and support
for large installations. Enterprise binaries and Docker images carry the `enterprise` suffix in their names and tags.

Enterprise components are free to use in non-production setups with
a [trial license](https://victoriametrics.com/products/enterprise/trial/). Production use requires an Enterprise
contract. [VictoriaMetrics Cloud](https://docs.victoriametrics.com/victoriametrics-cloud/) is built on top of
VictoriaMetrics Enterprise.

## Long-term support releases

// TODO: READINESS: LTS releases for VL VT

[LTS release lines](https://docs.victoriametrics.com/victoriametrics/lts-releases/) suit teams that prefer rare,
low-risk updates. Every line receives bugfixes and security fixes for 12 months, a new line appears every 6 months, and
two lines are supported at any moment.

LTS lines are published for VictoriaMetrics only. VictoriaLogs and VictoriaTraces have no LTS releases, so follow their
latest versions.

Every fix that lands in an LTS release also lands in the latest release, so users of the community edition get the same
fixes by [upgrading](http://localhost:1313/victoriastack/deployment/#upgrades) to the latest version.
