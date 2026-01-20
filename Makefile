APP_NAME := http-metrics-exporter
VERSION := v1.0.0
BINARY_NAME := app
GO_BUILD_FLAGS := -ldflags="-w -s"
GO_TEST_FLAGS := -v
DOCKER_REGISTRY := zhhray

GO := go
GOFMT := gofmt
GOIMPORTS := goimports
GO_LINT := golangci-lint

BUILD_DIR := build
DIST_DIR := dist
COVERAGE_DIR := coverage

.PHONY: all build clean test lint fmt docker-build docker-push docker-run help

all: clean fmt lint test build

build: build-linux build-darwin

build-linux:
	@echo "Building Linux amd64 binary..."
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 $(GO) build $(GO_BUILD_FLAGS) -o $(BUILD_DIR)/$(BINARY_NAME)-linux-amd64 .
	@echo "Binary built: $(BUILD_DIR)/$(BINARY_NAME)-linux-amd64"

build-darwin:
	@echo "Building Darwin amd64 binary..."
	CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 $(GO) build $(GO_BUILD_FLAGS) -o $(BUILD_DIR)/$(BINARY_NAME)-darwin-amd64 .
	@echo "Binary built: $(BUILD_DIR)/$(BINARY_NAME)-darwin-amd64"

build-all: build-linux build-darwin build-windows

build-windows:
	@echo "Building Windows amd64 binary..."
	CGO_ENABLED=0 GOOS=windows GOARCH=amd64 $(GO) build $(GO_BUILD_FLAGS) -o $(BUILD_DIR)/$(BINARY_NAME)-windows-amd64.exe .
	@echo "Binary built: $(BUILD_DIR)/$(BINARY_NAME)-windows-amd64.exe"

test:
	@echo "Running tests..."
	$(GO) test $(GO_TEST_FLAGS) ./...
	@echo "Tests completed"

test-coverage:
	@echo "Running tests with coverage..."
	mkdir -p $(COVERAGE_DIR)
	$(GO) test $(GO_TEST_FLAGS) -coverprofile=$(COVERAGE_DIR)/coverage.out ./...
	$(GO) tool cover -html=$(COVERAGE_DIR)/coverage.out -o $(COVERAGE_DIR)/coverage.html
	@echo "Coverage report generated: $(COVERAGE_DIR)/coverage.html"

fmt:
	@echo "Formatting code..."
	$(GOFMT) -w .
	$(GOIMPORTS) -w .
	@echo "Code formatted"

lint:
	@echo "Linting code..."
	@if command -v $(GO_LINT) > /dev/null; then \
		$(GO_LINT) run; \
	else \
		echo "golangci-lint not installed, skipping..."; \
		echo "Install with: go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest"; \
	fi
	@echo "Lint completed"

clean:
	@echo "Cleaning build files..."
	rm -rf $(BUILD_DIR) $(DIST_DIR) $(COVERAGE_DIR)
	@echo "Clean completed"

prepare-docker:
	@echo "Preparing for Docker build..."
	mkdir -p $(BUILD_DIR)
	$(MAKE) build-linux
	cp $(BUILD_DIR)/$(BINARY_NAME)-linux-amd64 $(BUILD_DIR)/$(BINARY_NAME)
	@echo "Docker preparation completed"

docker-build: prepare-docker
	@echo "Building Docker image..."
	docker build -f Dockerfile.local -t $(APP_NAME):$(VERSION) .
	@echo "Docker image built: $(APP_NAME):$(VERSION)"

docker-tag:
	@echo "Tagging Docker image..."
	docker tag $(APP_NAME):$(VERSION) $(DOCKER_REGISTRY)/$(APP_NAME):$(VERSION)
	docker tag $(APP_NAME):$(VERSION) $(DOCKER_REGISTRY)/$(APP_NAME):latest
	@echo "Images tagged"

docker-push: docker-build docker-tag
	@echo "Pushing Docker images..."
	docker push $(DOCKER_REGISTRY)/$(APP_NAME):$(VERSION)
	docker push $(DOCKER_REGISTRY)/$(APP_NAME):latest
	@echo "Images pushed"

docker-run: docker-build
	@echo "Running Docker container..."
	docker run -d --name $(APP_NAME) -p 8080:8080 $(APP_NAME):$(VERSION)
	@echo "Container started. Access at http://localhost:8080"

docker-stop:
	@echo "Stopping Docker container..."
	-docker stop $(APP_NAME)
	-docker rm $(APP_NAME)
	@echo "Container stopped"

package:
	@echo "Packaging release..."
	mkdir -p $(DIST_DIR)
	tar -czf $(DIST_DIR)/$(APP_NAME)-$(VERSION)-linux-amd64.tar.gz -C $(BUILD_DIR) $(BINARY_NAME)-linux-amd64
	tar -czf $(DIST_DIR)/$(APP_NAME)-$(VERSION)-darwin-amd64.tar.gz -C $(BUILD_DIR) $(BINARY_NAME)-darwin-amd64
	zip -j $(DIST_DIR)/$(APP_NAME)-$(VERSION)-windows-amd64.zip $(BUILD_DIR)/$(BINARY_NAME)-windows-amd64.exe
	@echo "Packages created in $(DIST_DIR)"

validate-image:
	@echo "Validating Docker image..."
	docker run --rm -p 8080:8080 -d --name validate-$(APP_NAME) $(APP_NAME):$(VERSION)
	sleep 5
	@echo "Testing health endpoint..."
	curl -f http://localhost:8080/health || (echo "Health check failed" && exit 1)
	@echo "Testing metrics endpoint..."
	curl -f http://localhost:8080/metrics | grep -q "http_requests_total" || (echo "Metrics endpoint failed" && exit 1)
	docker stop validate-$(APP_NAME)
	@echo "Image validation passed"

release: clean fmt lint test-coverage build-all package docker-build validate-image
	@echo "Release $(VERSION) ready!"
	@echo "Run 'make docker-push' to push to registry"

k8s-deploy-local:
	@echo "Deploying to local Kubernetes..."
	kubectl apply -f deployment.yaml
	kubectl apply -f service.yaml
	@echo "Deployment completed. Run 'kubectl get pods' to check status"

doc:
	@echo "Generating API documentation..."
	$(GO) run main.go -doc > API.md
	@echo "API documentation generated: API.md"

bench:
	@echo "Running benchmarks..."
	$(GO) test -bench=. -benchmem ./...
	@echo "Benchmarks completed"

help:
	@echo "Available targets:"
	@echo "  all              - Clean, format, lint, test and build"
	@echo "  build            - Build binaries for Linux and macOS"
	@echo "  build-linux      - Build Linux amd64 binary"
	@echo "  build-darwin     - Build macOS amd64 binary"
	@echo "  build-windows    - Build Windows amd64 binary"
	@echo "  build-all        - Build binaries for all platforms"
	@echo "  test             - Run tests"
	@echo "  test-coverage    - Run tests with coverage report"
	@echo "  fmt              - Format code"
	@echo "  lint             - Lint code"
	@echo "  clean            - Clean build files"
	@echo "  docker-build     - Build Docker image"
	@echo "  docker-push      - Build and push Docker image to registry"
	@echo "  docker-run       - Build and run Docker container locally"
	@echo "  docker-stop      - Stop Docker container"
	@echo "  package          - Create release packages"
	@echo "  validate-image   - Validate Docker image functionality"
	@echo "  release          - Full release process"
	@echo "  k8s-deploy-local - Deploy to local Kubernetes"
	@echo "  doc              - Generate API documentation"
	@echo "  bench            - Run benchmarks"
	@echo "  help             - Show this help message"

.DEFAULT_GOAL := help