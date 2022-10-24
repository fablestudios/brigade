IMAGE ?= fablestudios/brigade
COMMIT ?= $(shell git rev-parse --short HEAD)
TAG := $(shell date -u +%Y%m%d-%H%M%S)-$(COMMIT)
PLATFORMS ?= linux/amd64,linux/arm64

.PHONY: all brigade image

all: image

brigade:
	go build

image:
	docker buildx build --platform $(PLATFORMS) --push -t $(IMAGE):$(TAG) .
