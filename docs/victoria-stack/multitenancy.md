---
title: Multitenancy
menu:
  docs:
    weight: 6
    identifier: victoria-stack-multitenancy
    parent: victoria-stack
tags:
  - metrics
  - logs
  - traces
---

## Multitenancy

VictoriaMetrics, VictoriaLogs and VictoriaTraces databases support multitenancy.
A tenant is identified by (AccountID, ProjectID) pair, where AccountID and ProjectID are arbitrary 32-bit unsigned
integers.
The AccountID and ProjectID can be set during [data ingestion]() and [querying]() via AccountID and ProjectID request
headers.

> Please note, VictoriaMetrics supports multitenancy only in [cluster mode](https://docs.victoriametrics.com/victoriametrics/#multi-tenancy).
> The further details in this section will assume that VictoriaMetrics is running in cluster mode.
