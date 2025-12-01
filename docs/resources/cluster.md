---
page_title: "scylladbcloud_cluster Resource - terraform-provider-scylladbcloud"
subcategory: "Cluster Management"
description: |-
  Manages a ScyllaDB Cloud cluster. A cluster is a group of nodes running ScyllaDB that work together to store and manage data.
---

# scylladbcloud_cluster (Resource)

Manages a ScyllaDB Cloud cluster. A cluster is a group of nodes running ScyllaDB that work together to store and manage data with automatic replication and distribution.

Use this resource to create and manage dedicated ScyllaDB clusters on AWS or GCP. For serverless deployments, use the [`scylladbcloud_serverless_cluster`](serverless_cluster) resource instead.

-> **Note:** Once a cluster is created, most attributes cannot be modified. Changes to immutable attributes will require destroying and recreating the cluster.

## Example Usage

### Basic Cluster on AWS

```terraform
# Create a cluster on AWS cloud.
resource "scylladbcloud_cluster" "example" {
	name       = "My Cluster"
	cloud      = "AWS"
	region     = "us-east-1"
	node_count = 3
	node_type  = "i3.xlarge"
	cidr_block = "172.31.0.0/16"

	enable_vpc_peering = true
	enable_dns         = true
	
	# Enable encryption at rest (AWS only)
	encryption_at_rest = true
	
	# Replication factor (default is 3)
	replication_factor = 3
}

output "scylladbcloud_cluster_id" {
	value = scylladbcloud_cluster.example.id
}

output "scylladbcloud_cluster_datacenter" {
	value = scylladbcloud_cluster.example.datacenter
}
```

### Cluster with Encryption at Rest (AWS Only)

```terraform
resource "scylladbcloud_cluster" "encrypted" {
  name       = "Encrypted Cluster"
  cloud      = "AWS"
  region     = "us-east-1"
  node_count = 3
  node_type  = "i3.xlarge"
  cidr_block = "172.31.0.0/16"

  enable_vpc_peering = true
  enable_dns         = true
  encryption_at_rest = true
  replication_factor = 3
}
```

### Cluster on GCP

```terraform
resource "scylladbcloud_cluster" "gcp" {
  name       = "GCP Cluster"
  cloud      = "GCP"
  region     = "us-central1"
  node_count = 3
  node_type  = "n2-highmem-4"
  cidr_block = "10.0.0.0/16"

  enable_vpc_peering = true
  enable_dns         = true
  replication_factor = 3
}
```

### Cluster with Alternator (DynamoDB-compatible API)

```terraform
resource "scylladbcloud_cluster" "alternator" {
  name               = "Alternator Cluster"
  cloud              = "AWS"
  region             = "us-west-2"
  node_count         = 3
  node_type          = "i3.xlarge"
  cidr_block         = "172.31.0.0/16"
  user_api_interface = "ALTERNATOR"

  alternator_write_isolation = "only_rmw_uses_lwt"
  enable_vpc_peering         = true
  enable_dns                 = true
}
```

## Argument Reference

This resource supports the following arguments:

### Required

* `name` - (Required) The name of the cluster. Must be unique within your ScyllaDB Cloud account.
* `region` - (Required, Forces new resource) The cloud provider region where the cluster will be deployed (e.g., `us-east-1` for AWS, `us-central1` for GCP).
* `node_count` - (Required, Forces new resource) The number of nodes in the cluster. Minimum recommended is 3 for production workloads.
* `node_type` - (Required, Forces new resource) The instance type for cluster nodes. Available types depend on the cloud provider:
  * **AWS**: `i3.xlarge`, `i3.2xlarge`, `i3.4xlarge`, `i3.8xlarge`, `i3.16xlarge`, `i3.metal`, `i3en.xlarge`, `i3en.2xlarge`, `i3en.3xlarge`, `i3en.6xlarge`, `i3en.12xlarge`, `i3en.24xlarge`
  * **GCP**: `n2-highmem-4`, `n2-highmem-8`, `n2-highmem-16`, `n2-highmem-32`, `n2-highmem-64`

### Optional

* `cloud` - (Optional, Forces new resource) The cloud provider for the cluster. Valid values are `AWS` (default) or `GCP`.
* `cidr_block` - (Optional, Forces new resource) The IPv4 CIDR block for the cluster's VPC. Defaults to `172.31.0.0/16`. Must not overlap with your application VPC if using VPC peering.
* `scylla_version` - (Optional, Forces new resource) The ScyllaDB version to use. If not specified, the latest stable version is used.
* `enable_vpc_peering` - (Optional, Forces new resource) Whether to enable VPC peering capability. When `false`, nodes are accessible via public IPs. Defaults to `true`.
* `enable_dns` - (Optional) Whether to enable DNS names (CNAME records) for seed nodes. Defaults to `true`.
* `replication_factor` - (Optional, Forces new resource) The replication factor for data. Determines how many copies of data are stored across nodes. Defaults to `3`.
* `node_disk_size` - (Optional, Forces new resource) The disk size in gigabytes for each node. If not specified, the default size for the selected instance type is used.
* `encryption_at_rest` - (Optional, Forces new resource) Enable encryption at rest for data stored on disk. **Only supported for AWS**. Defaults to `false`.
* `user_api_interface` - (Optional, Forces new resource) The API interface type. Valid values are `CQL` (default) for Cassandra Query Language or `ALTERNATOR` for DynamoDB-compatible API.
* `alternator_write_isolation` - (Optional, Forces new resource) The default write isolation policy for Alternator. Only applicable when `user_api_interface` is `ALTERNATOR`. Valid values are:
  * `always_use_lwt` - Always use lightweight transactions
  * `only_rmw_uses_lwt` - Only read-modify-write operations use lightweight transactions (default)
  * `forbid_rmw` - Forbid read-modify-write operations
  * `unsafe_rmw` - Allow unsafe read-modify-write operations
* `byoa_id` - (Optional, Forces new resource) The BYOA (Bring Your Own Account) credential ID. Only applicable for AWS deployments where you want the cluster deployed in your own AWS account.

### Timeouts

`timeouts` block allows you to specify [timeouts](https://developer.hashicorp.com/terraform/language/resources/syntax#operation-timeouts) for certain operations:

* `create` - (Default `40m`) Time to wait for cluster creation to complete.
* `update` - (Default `40m`) Time to wait for cluster updates to complete.
* `delete` - (Default `90m`) Time to wait for cluster deletion to complete.

## Attribute Reference

This resource exports the following attributes in addition to the arguments above:

* `id` - The Terraform resource ID (same as `cluster_id`).
* `cluster_id` - The numeric ID of the cluster in ScyllaDB Cloud.
* `datacenter` - The name of the cluster's datacenter (e.g., `AWS_US_EAST_1`).
* `status` - The current status of the cluster (e.g., `ACTIVE`, `CREATING`, `DELETING`).
* `node_dns_names` - A set of DNS names for the cluster nodes. Only populated when `enable_dns` is `true`.
* `node_private_ips` - A set of private IP addresses for the cluster nodes.
* `request_id` - The ID of the cluster creation request.

## Import

Import is supported using the following syntax:

```shell
# A cluster can be imported by specifying the numeric identifier.
terraform import scylladbcloud_cluster.example 123
```

~> **Note:** After importing, you may need to run `terraform plan` to ensure the state matches your configuration. Some computed attributes will be populated during the next `terraform apply`.

## Related Resources

* [scylladbcloud_vpc_peering](vpc_peering) - Configure VPC peering for the cluster
* [scylladbcloud_allowlist_rule](allowlist_rule) - Configure IP allowlist rules for cluster access
* [scylladbcloud_cql_auth](../data-sources/cql_auth) - Retrieve CQL authentication credentials
