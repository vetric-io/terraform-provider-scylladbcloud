terraform-provider-scylladbcloud
================================

## ⚠️ This is NOT the official ScyllaDB Cloud Terraform Provider

> **This is a fork maintained by [Vetric](https://github.com/vetric-io) with additional features and enhancements.**
> 
> For the official provider, please visit: [github.com/scylladb/terraform-provider-scylladbcloud](https://github.com/scylladb/terraform-provider-scylladbcloud)

---

## Installation

This provider is available on the [Terraform Registry](https://registry.terraform.io/providers/vetric-io/scylladbcloud/latest).

```hcl
terraform {
  required_providers {
    scylladbcloud = {
      source  = "vetric-io/scylladbcloud"
      version = "~> 1.0"
    }
  }
}
```

Then run `terraform init` to download and install the provider.

### Build from Source (Development)

```bash
git clone https://github.com/vetric-io/terraform-provider-scylladbcloud.git
cd terraform-provider-scylladbcloud
go build -o terraform-provider-scylladbcloud
```

---

## Provider Configuration

Configure your Terraform to use this provider:

```hcl
terraform {
  required_providers {
    scylladbcloud = {
      source  = "vetric-io/scylladbcloud"
      version = "~> 1.0"
    }
  }
}

provider "scylladbcloud" {
  token = "..."  # Your ScyllaDB Cloud API Token
}
```

---

## Additional Features in This Fork

This fork includes the following enhancements not yet available in the official provider:

### Cluster Resource (`scylladbcloud_cluster`)

| Feature | Description |
|---------|-------------|
| `encryption_at_rest` | Enable encryption at rest for your cluster data (AWS only) |
| `replication_factor` | Configure the replication factor for your cluster (default: 3) |

### Fixes

| Resource | Fix |
|----------|-----|
| `scylladbcloud_vpc_peering` | Fixed examples to use `peer_cidr_blocks` (list) instead of `peer_cidr_block` |

### Documentation Improvements

This fork includes comprehensive documentation:

- **Detailed Argument Reference** - Each argument documented with (Required/Optional), default values, and valid options
- **Attribute Reference** - Clear documentation of all computed outputs
- **Multiple Examples** - Practical examples for AWS, GCP, and different use cases
- **Tips & Warnings** - Important notes about cloud-specific features and best practices
- **Related Resources** - Cross-links between related resources and data sources
- **Timeouts Documentation** - Default timeout values for create/update/delete operations
- **Import Instructions** - Clear syntax for importing existing resources

---

## About

This is the repository for the Terraform Scylla Cloud Provider, which allows one to use Terraform with ScyllaDB's Database as a Service, Scylla Cloud. For general information about Terraform, visit the official website and the GitHub project page. For details about Scylla Cloud, see [Scylla Cloud Documentation](https://cloud.docs.scylladb.com).
The provider is using [Scylla Cloud REST API](https://cloud.docs.scylladb.com/stable/api-docs/api-get-started.html).


### Prerequisites

* Terraform 0.13+
* Go 1.18+ (to build the provider plugin)
* [Scylla Cloud](https://cloud.scylladb.com/) Account
* [Scylla Cloud API Token](https://cloud.docs.scylladb.com/stable/api-docs/create-api-token.html)

### Example Usage

```hcl
terraform {
  required_providers {
    scylladbcloud = {
      source  = "vetric-io/scylladbcloud"
      version = "~> 1.0"
    }
  }
}

provider "scylladbcloud" {
  token = var.scylladb_token
}

resource "scylladbcloud_cluster" "example" {
  name       = "My Cluster"
  cloud      = "AWS"
  region     = "us-east-1"
  node_count = 3
  node_type  = "i3.xlarge"
  cidr_block = "172.31.0.0/16"

  enable_vpc_peering = true
  enable_dns         = true
  
  # Fork-specific features
  encryption_at_rest = true
  replication_factor = 3
}
```

Run `terraform apply` to create a cluster or `terraform destroy` to delete it.

### Import Existing Resources

You can import an existing cluster by providing its ID:

```hcl
resource "scylladbcloud_cluster" "mycluster" { }
```

```bash
terraform import scylladbcloud_cluster.mycluster 123
```

### Debugging

For debugging / troubleshooting please see [Terraform debugging documentation](https://developer.hashicorp.com/terraform/internals/debugging).

---

## Links

- **GitHub Repository**: https://github.com/vetric-io/terraform-provider-scylladbcloud
- **Original Provider**: https://github.com/scylladb/terraform-provider-scylladbcloud
- **ScyllaDB Cloud Docs**: https://cloud.docs.scylladb.com

---

## License

Apache-2.0 - See [LICENSE.md](LICENSE.md) for details.

