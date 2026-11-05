# VictoriaStack

This repository contains documentation for https://docs.victoriametrics.com/victoriastack/ and [examples for running the stack locally](https://github.com/VictoriaMetrics/VictoriaStack/tree/main/deployment) via docker-compose.

# Documentation

> **Note:** This command is only available if you're a part of the VictoriaMetrics organization on GitHub.

To run the docs locally:
```shell
make docs-debug 
```

Visit http://localhost:1313/ - see left nav bar for VictoriaStack section.

Image sources are located at [Excalidraw+](https://app.excalidraw.com/s/4YgcNXX7lhO/43QV2antCeJ).

# Docker compose demo

For running a demo, first clone this repo:
```sh
git clone https://github.com/VictoriaMetrics/VictoriaStack.git && cd VictoriaStack
```

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

# Contributing

Feel free to open issues and PRs with proposed changes.