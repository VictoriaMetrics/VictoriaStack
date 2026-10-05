
# Docs

To run the docs locally:
```shell
make docs-debug 
```

Visit http://localhost:1313/ - see left nav bar for VictoriaStack section.

Image sources are located at [Excalidraw+](https://app.excalidraw.com/s/4YgcNXX7lhO/43QV2antCeJ).
I didn't put them locally as I assume they will be changing a lot until the stable release.

# Docker compose demo

## Single-node

To run the stack with single-nodes locally:
```sh
make otel-single-up
```

To stop the stack with single-nodes:
```
make otel-single-down
```

## Cluster

To run the stack with clusters locally:
```sh
make otel-cluster-up
```

To stop the stack with clusters:
```
make otel-cluster-down
```

# Readiness

See the list of features that are missing in the products to make the stack aligned.

## UI 

- // TODO: READINESS: visum to become all-in-one
- // TODO: READINESS: make a unified usage dashboards for all signals per-tenant  https://github.com/VictoriaMetrics/VictoriaStack/issues/7

## VictoriaTraces

- // TODO: READINESS: per-tenant retention in VL/VT
- // TODO: READINESS: multitenant reads in VL/VT https://github.com/VictoriaMetrics/VictoriaLogs/issues/91
- // TODO: READINESS: backups VL/VT https://github.com/VictoriaMetrics/VictoriaLogs/issues/123
- // TODO: READINESS: VTDistributed https://github.com/VictoriaMetrics/operator/issues/2515
- // TODO: READINESS: VLDistributed/VMDistributed are marked as experimental https://github.com/VictoriaMetrics/operator/issues/2329
- // TODO: READINESS: LTS releases for VT
- // TODO: READINESS: Assigning tenants via fields in VL/VT https://github.com/VictoriaMetrics/VictoriaLogs/issues/686
- // TODO: READINESS: Add #querying-tenants docs to https://docs.victoriametrics.com/victoriatraces/querying -  https://github.com/VictoriaMetrics/VictoriaLogs/issues/686


## VictoriaLogs

- // TODO: READINESS: per-tenant retention in VL/VT
- // TODO: READINESS: multitenant reads in VL/VT https://github.com/VictoriaMetrics/VictoriaLogs/issues/91
- // TODO: READINESS: backups VL/VT https://github.com/VictoriaMetrics/VictoriaLogs/issues/123
- // TODO: READINESS: VLDistributed/VMDistributed are marked as experimental https://github.com/VictoriaMetrics/operator/issues/2329
- // TODO: READINESS: Assigning tenants via fields in VL/VT https://github.com/VictoriaMetrics/VictoriaLogs/issues/686
- // TODO: READINESS: Add #querying-tenants docs to https://docs.victoriametrics.com/victoriatraces/querying -  https://github.com/VictoriaMetrics/VictoriaLogs/issues/686
