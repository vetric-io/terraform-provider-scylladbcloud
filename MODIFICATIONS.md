# Modifications

This repository is a fork of [scylladb/terraform-provider-scylladbcloud](https://github.com/scylladb/terraform-provider-scylladbcloud), licensed under the Apache License 2.0 (see [LICENSE.md](LICENSE.md)).

Vetric Technology Ltd. changed the files listed below, starting December 2025. [CHANGELOG.md](CHANGELOG.md) describes each change. The comparison base is upstream commit [`284f106`](https://github.com/scylladb/terraform-provider-scylladbcloud/commit/284f106d1f7448c5fb30ff95cd5816b485d2f3fe), the last upstream commit merged into this fork.

## Files changed by Vetric

Source code (each file also carries a notice at the top):

- `main.go`
- `internal/provider/provider.go`
- `internal/provider/cluster/cluster.go`
- `internal/scylla/model/model.go`

Module and build configuration:

- `go.mod`, `go.sum`
- `Makefile`
- `.goreleaser.yml`
- `.github/workflows/release.yml`, `.github/workflows/go.yml`
- `.github/dependabot.yml`
- `.gitignore`

Examples (these are embedded in the generated documentation, so they carry no inline notice):

- `examples/provider/provider.tf`
- `examples/data-sources/scylladbcloud_serverless_bundle/data-source.tf`
- `examples/resources/scylladbcloud_cluster/resource.tf`
- `examples/resources/scylladbcloud_vpc_peering/aws.tf`
- `examples/resources/scylladbcloud_vpc_peering/resource.tf`

Documentation:

- `README.md`, `CONTRIBUTING.md`
- `templates/resources/allowlist_rule.md.tmpl`, `cluster.md.tmpl`, `cluster_connection.md.tmpl`, `serverless_cluster.md.tmpl`, `vpc_peering.md.tmpl`
- `docs/data-sources/cql_auth.md`, `serverless_bundle.md`
- `docs/index.md`
- `docs/resources/allowlist_rule.md`, `cluster.md`, `cluster_connection.md`, `serverless_cluster.md`, `vpc_peering.md`

All other files are either unchanged from upstream or were added by Vetric.

## Third-party components

The release binaries statically include third-party Go modules. Their licence notices are in [THIRD_PARTY_NOTICES](THIRD_PARTY_NOTICES), which ships in every release archive. Modules under the Mozilla Public License 2.0 are used unmodified. Their source code is available from each module's upstream repository, at the version recorded in `go.sum`.
