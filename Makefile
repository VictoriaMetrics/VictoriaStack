DOCKER ?= docker
DOCKER_COMPOSE ?= $(DOCKER) compose

include docs/Makefile

otel-single-up:
	$(DOCKER_COMPOSE) -f deployment/otel-compose.yml up -d

otel-single-down:
	$(DOCKER_COMPOSE) -f deployment/otel-compose.yml down -v


otel-cluster-up:
	$(DOCKER_COMPOSE) -f deployment/otel-cluster-compose.yml up -d

otel-cluster-down:
	$(DOCKER_COMPOSE) -f deployment/otel-cluster-compose.yml down -v