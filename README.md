
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

See features that are missing in the products to make the stack aligned.

## 1. VictoriaTraces component parity

The traces side lacks the agent and orchestration pieces that metrics and logs already have.

- vtagent for optimized ingestion path
- vtagent for replication
- VTDistributed

## 2. Logs and traces parity with metrics

Features that exist for VictoriaMetrics only, each already documented as metrics-only on the page.

- Cross-tenant queries in VL/VT
- Per-tenant retention in VL/VT
- LTS releases for VL/VT
- [VictoriaLogs#686: ingestion: support specifying tenant id in logs instead of headers](https://github.com/VictoriaMetrics/VictoriaLogs/issues/686)
- [VictoriaLogs#123: vmbackup/vmrestore/vmbackupmanager for VMLogs](https://github.com/VictoriaMetrics/VictoriaLogs/issues/123)

## 3. VictoriaMetrics defaults and maturity

- VLDistributed/VMDistributed marked experimental
- [VictoriaMetrics#11365: cluster: consider enabling -enableMultitenanhttps://github.com/VictoriaMetrics/VictoriaMetrics/issues/11365)

## 4. UI

- visum to become all-in-one UI solution 

## 5. Upstream docs gaps

- Add `#querying-tenants` docs to `victoriatraces/querying`