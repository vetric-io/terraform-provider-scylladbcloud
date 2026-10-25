GOPATH?=$(shell go env GOPATH)
GO_LICENSES_VERSION=v2.0.1
GO_LICENSES=$(CURDIR)/bin/go-licenses
NOTICES_RULE=================================================================================

build:
	CGO_ENABLED=0 go build -o terraform-provider-scylladbcloud .

fmt:
	go tool gofumpt -w -l .

generate:
	go generate ./...

lint: $(GOPATH)/bin/golangci-lint
	go tool gofumpt -l -d -e .
	$(GOPATH)/bin/golangci-lint run ./...

# Install golangci-lint following https://golangci-lint.run/docs/welcome/install/local/.
# go tool is not recommended.
# Pin to specific commit SHA aligned with the requested version.
# The install.sh script performs checksum verification of the downloaded binary.
$(GOPATH)/bin/golangci-lint:
	curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/9f61b0f53f80672872fced07b6874397c3ed197b/install.sh | sh -s -- -b $(GOPATH)/bin v2.7.2

# Third-party notices for the Go modules compiled into the release binaries,
# shipped in every release archive (see .goreleaser.yml). go-licenses is
# installed for the host and pointed at the linux build through GOOS, because
# `go tool` / `go run` with GOOS set would cross-compile the tool itself.
# It is kept out of go.mod so its dependencies cannot change the provider's.
# `go-licenses save` copies MPL module sources, so it writes outside the module
# tree, where `go build ./...` and the linters cannot pick them up.
notices: NOTICES_DIR:=$(shell mktemp -d)
notices: $(GO_LICENSES)
	GOOS=linux GOARCH=amd64 CGO_ENABLED=0 $(GO_LICENSES) save . \
		--ignore github.com/scylladb/terraform-provider-scylladbcloud \
		--save_path $(NOTICES_DIR) --force
	{ GOOS=linux GOARCH=amd64 CGO_ENABLED=0 $(GO_LICENSES) report . \
		--ignore github.com/scylladb/terraform-provider-scylladbcloud \
		--template tools/third-party-notices.tmpl; \
	  cat tools/go-stdlib-LICENSE; \
	  printf '\n%s\n\nNOTICE files of the modules above (Apache License 2.0, section 4(d))\n' "$(NOTICES_RULE)"; \
	  find $(NOTICES_DIR) -iname 'NOTICE*' -type f | sort | while read -r f; do \
	    printf '\n--- %s\n\n' "$${f#$(NOTICES_DIR)/}"; cat "$$f"; \
	  done; } > THIRD_PARTY_NOTICES
	rm -rf $(NOTICES_DIR)

$(GO_LICENSES):
	GOBIN=$(CURDIR)/bin go install github.com/google/go-licenses/v2@$(GO_LICENSES_VERSION)

# Git hooks management using lefthook
install-hooks:
	go tool lefthook install

uninstall-hooks:
	go tool lefthook uninstall

# Run hooks manually without committing
run-hooks:
	go tool lefthook run pre-commit

.PHONY: build fmt generate lint notices install-hooks uninstall-hooks run-hooks
