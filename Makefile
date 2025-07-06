.PHONY: build-x86 build-arm64 push all tag tag-push release

# Build Vars
IMAGENAME=johnlin/bpfshoot
VERSION?=0.0.1

# Get the latest git tag or use VERSION if no tags exist
GIT_TAG := $(shell git describe --tags --exact-match 2>/dev/null || echo "v$(VERSION)")
GIT_LATEST_TAG := $(shell git describe --tags --abbrev=0 2>/dev/null || echo "v$(VERSION)")

.DEFAULT_GOAL := all

build-x86:
	    @docker build --platform linux/amd64 -t ${IMAGENAME}:${VERSION} .
build-arm64:
		@docker build --platform linux/arm64 -t ${IMAGENAME}:${VERSION} .
build-all:
		@docker buildx build --platform linux/amd64,linux/arm64 --output "type=image,push=false" --file ./Dockerfile .
push:
	 	@docker push ${IMAGENAME}:${VERSION} 
all: build-all push

# Create a git tag
tag:
	@echo "Creating git tag v$(VERSION)"
	@git tag -a v$(VERSION) -m "Release v$(VERSION)"
	@echo "Created tag v$(VERSION)"

# Push git tag to remote
tag-push: tag
	@echo "Pushing tag v$(VERSION) to remote"
	@git push origin v$(VERSION)
	@echo "Tag v$(VERSION) pushed to remote"

# Create and push tag, then trigger CI build
release: tag-push
	@echo "Release v$(VERSION) created and pushed"
	@echo "GitHub Actions will automatically build and push Docker images"
	@echo "Images will be tagged as:"
	@echo "  - $(IMAGENAME):$(VERSION)"
	@echo "  - $(IMAGENAME):$(VERSION)-bcc"
	@echo "  - $(IMAGENAME):latest"
	@echo "  - $(IMAGENAME):latest-bcc"

