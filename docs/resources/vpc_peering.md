---
page_title: "scylladbcloud_vpc_peering Resource - terraform-provider-scylladbcloud"
subcategory: "Networking"
description: |-
  Manages a VPC peering connection between a ScyllaDB Cloud cluster and your cloud provider VPC.
---

# scylladbcloud_vpc_peering (Resource)

Manages a VPC peering connection between a ScyllaDB Cloud cluster and your cloud provider VPC. VPC peering enables private network connectivity between your application infrastructure and ScyllaDB Cloud clusters.

-> **Note:** VPC peering requires additional configuration on your cloud provider side to accept the peering connection and set up routing. See the examples below for complete end-to-end configurations.

~> **Important:** The cluster must have `enable_vpc_peering = true` set during creation to support VPC peering connections.

## Example Usage

### Basic VPC Peering

```terraform
# Create a VPC peering connection to the specified datacenter.
resource "scylladbcloud_vpc_peering" "example" {
	cluster_id = 1337
	datacenter = "AWS_US_EAST_1"

	peer_vpc_id      = "vpc-1234"
	peer_cidr_blocks = ["192.168.0.0/16"]
	peer_region      = "us-east-1"
	peer_account_id  = "123"

	allow_cql = true
}

output "scylladbcloud_vpc_peering_connection_id" {
	value = scylladbcloud_vpc_peering.example.connection_id
}
```

### Complete AWS VPC Peering Setup

This example shows the complete setup including the AWS side configuration:

```terraform
# End-to-end example for ScyllaDB Datacenter VPC peering on AWS.
resource "scylladbcloud_cluster" "example" {
	name       = "My Cluster"
	cloud      = "AWS"
	region     = "us-east-1"
	node_count = 3
	node_type  = "i3.xlarge"
	cidr_block = "172.31.0.0/16"

	enable_vpc_peering = true
	enable_dns         = true
}

resource "aws_vpc" "app" {
	cidr_block = "10.0.0.0/16"
}

data "aws_caller_identity" "current" {}

resource "scylladbcloud_vpc_peering" "example" {
	cluster_id = scylladbcloud_cluster.example.cluster_id
	datacenter = scylladbcloud_cluster.example.datacenter

	peer_vpc_id       = aws_vpc.app.id
	peer_cidr_blocks  = [aws_vpc.app.cidr_block]
	peer_region       = "us-east-1"
	peer_account_id   = data.aws_caller_identity.current.account_id

	allow_cql = true
}

resource "aws_vpc_peering_connection_accepter" "app" {
    vpc_peering_connection_id = scylladbcloud_vpc_peering.example.connection_id
    auto_accept               = true
}

resource "aws_route_table" "app" {
	vpc_id = aws_vpc.app.id

	route {
		cidr_block                = scylladbcloud_cluster.example.cidr_block
		vpc_peering_connection_id = aws_vpc_peering_connection_accepter.app.vpc_peering_connection_id
	}
}
```

### Complete GCP Network Peering Setup

This example shows the complete setup for GCP:

```terraform
# End-to-end example for ScyllaDB Datacenter network peering on GCP.
resource "google_compute_network" "app" {
	name = "app"
	auto_create_subnetworks = true
}

resource "scylladbcloud_vpc_peering" "example" {
	cluster_id = 1337
	datacenter = "GCE_US_CENTRAL_1"

	peer_vpc_id     = google_compute_network.app.name
	peer_region     = "us-central1"
	peer_account_id = "exampleproject"

	allow_cql = true
}

resource "google_compute_network_peering" "app" {
	name         = "app-peering"
	network      = google_compute_network.app.self_link
	peer_network = scylladbcloud_vpc_peering.example.network_link
}
```

## Argument Reference

This resource supports the following arguments:

### Required

* `cluster_id` - (Required) The numeric ID of the ScyllaDB Cloud cluster to peer with.
* `datacenter` - (Required, Forces new resource) The datacenter name of the cluster (e.g., `AWS_US_EAST_1`, `GCE_US_CENTRAL_1`). This determines which cloud provider and region the peering will be established in.
* `peer_vpc_id` - (Required, Forces new resource) The ID of your VPC to peer with:
  * **AWS**: The VPC ID (e.g., `vpc-1234567890abcdef0`)
  * **GCP**: The network name (e.g., `my-network`)
* `peer_region` - (Required, Forces new resource) The region of your VPC:
  * **AWS**: Region code (e.g., `us-east-1`, `eu-west-1`)
  * **GCP**: Region code (e.g., `us-central1`, `europe-west1`)
* `peer_account_id` - (Required, Forces new resource) Your cloud provider account identifier:
  * **AWS**: Your 12-digit AWS account ID (e.g., `123456789012`)
  * **GCP**: Your GCP project ID (e.g., `my-project-id`)

### Optional

* `peer_cidr_blocks` - (Optional, Forces new resource) A list of CIDR blocks for your VPC. **Required for AWS**, optional for GCP (defaults to GCP-assigned CIDR). Example: `["10.0.0.0/16", "10.1.0.0/16"]`
* `allow_cql` - (Optional) Whether to allow CQL traffic through the peering connection. Defaults to `true`.

### Timeouts

`timeouts` block allows you to specify [timeouts](https://developer.hashicorp.com/terraform/language/resources/syntax#operation-timeouts) for certain operations:

* `create` - (Default `40m`) Time to wait for VPC peering creation.
* `update` - (Default `40m`) Time to wait for VPC peering updates.
* `delete` - (Default `90m`) Time to wait for VPC peering deletion.

## Attribute Reference

This resource exports the following attributes in addition to the arguments above:

* `id` - The Terraform resource ID (same as `connection_id`).
* `vpc_peering_id` - The numeric ID of the VPC peering in ScyllaDB Cloud.
* `connection_id` - The cloud provider's VPC peering connection ID:
  * **AWS**: The VPC peering connection ID (e.g., `pcx-1234567890abcdef0`)
  * **GCP**: The network peering name
* `network_link` - (GCP only) The self_link URL of the ScyllaDB Cloud VPC network. Use this value when creating the `google_compute_network_peering` resource on your side.

## Import

Import is supported using the following syntax:

```shell
# A VPC peering connection can be imported by specifying the numeric identifier.
terraform import scylladbcloud_vpc_peering.example 123
```

## AWS Peering Workflow

After creating the `scylladbcloud_vpc_peering` resource:

1. **Accept the peering connection** using `aws_vpc_peering_connection_accepter`
2. **Update route tables** to route traffic to the ScyllaDB cluster CIDR through the peering connection
3. **Update security groups** (if needed) to allow traffic from ScyllaDB

```terraform
# Accept the peering connection
resource "aws_vpc_peering_connection_accepter" "scylla" {
  vpc_peering_connection_id = scylladbcloud_vpc_peering.example.connection_id
  auto_accept               = true
}

# Add route to ScyllaDB cluster
resource "aws_route" "scylla" {
  route_table_id            = aws_route_table.app.id
  destination_cidr_block    = scylladbcloud_cluster.example.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.scylla.vpc_peering_connection_id
}
```

## GCP Peering Workflow

After creating the `scylladbcloud_vpc_peering` resource:

1. **Create the peering connection on your side** using `google_compute_network_peering` with the `network_link` attribute
2. **Firewall rules** are typically not needed as GCP handles this automatically

```terraform
resource "google_compute_network_peering" "scylla" {
  name         = "scylla-peering"
  network      = google_compute_network.app.self_link
  peer_network = scylladbcloud_vpc_peering.example.network_link
}
```

## Related Resources

* [scylladbcloud_cluster](cluster) - The cluster resource that must be created first
* [scylladbcloud_allowlist_rule](allowlist_rule) - Configure IP allowlist rules for additional access control
