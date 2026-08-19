DOCKER ?= docker
DOCKER_COMPOSE ?= $(DOCKER) compose

include docs/Makefile

otel-single-up:
	$(DOCKER_COMPOSE) \
	-f deployment/otel-single-node.yml \
 	-f deployment/otel-demo-mini.yml \
 	up -d

otel-single-down:
	$(DOCKER_COMPOSE) \
	-f deployment/otel-single-node.yml \
	-f deployment/otel-demo-mini.yml \
	down -v


otel-cluster-up:
	$(DOCKER_COMPOSE) \
	-f deployment/otel-cluster.yml \
 	-f deployment/otel-demo-mini.yml \
 	up -d

otel-cluster-down:
	$(DOCKER_COMPOSE) \
	-f deployment/otel-cluster.yml \
 	-f deployment/otel-demo-mini.yml \
 	down -v
