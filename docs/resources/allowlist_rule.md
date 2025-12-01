---
page_title: "scylladbcloud_allowlist_rule Resource - terraform-provider-scylladbcloud"
subcategory: "Security"
description: |-
  Manages an IP allowlist rule for a ScyllaDB Cloud cluster.
---

# scylladbcloud_allowlist_rule (Resource)

Manages an IP allowlist rule for a ScyllaDB Cloud cluster. Allowlist rules control which IP addresses or CIDR blocks are permitted to connect to your cluster.

-> **Note:** When using VPC peering, traffic from peered VPCs is automatically allowed. Allowlist rules are primarily used for public access or additional IP-based access control.

~> **Security Best Practice:** Use the most specific CIDR blocks possible. Avoid using `0.0.0.0/0` (allow all) in production environments.

## Example Usage

```terraform
# Add a CIDR block to allowlist for the specified cluster.
resource "scylladbcloud_allowlist_rule" "example" {
	cluster_id = 1337
	cidr_block = "89.74.148.54/32"
}

output "scylladbcloud_allowlist_rule_id" {
	value = scylladbcloud_allowlist_rule.example.rule_id
}
```

### Allow Access from a Specific IP

```terraform
resource "scylladbcloud_allowlist_rule" "office" {
  cluster_id = scylladbcloud_cluster.main.cluster_id
  cidr_block = "203.0.113.10/32"  # Single IP address
}
```

### Allow Access from a Subnet

```terraform
resource "scylladbcloud_allowlist_rule" "datacenter" {
  cluster_id = scylladbcloud_cluster.main.cluster_id
  cidr_block = "10.0.0.0/24"  # Allow entire subnet
}
```

### Multiple Allowlist Rules

```terraform
resource "scylladbcloud_cluster" "main" {
  name       = "Production Cluster"
  cloud      = "AWS"
  region     = "us-east-1"
  node_count = 3
  node_type  = "i3.xlarge"
  cidr_block = "172.31.0.0/16"

  enable_vpc_peering = false  # Public access mode
  enable_dns         = true
}

# Allow office network
resource "scylladbcloud_allowlist_rule" "office" {
  cluster_id = scylladbcloud_cluster.main.cluster_id
  cidr_block = "203.0.113.0/24"
}

# Allow VPN network
resource "scylladbcloud_allowlist_rule" "vpn" {
  cluster_id = scylladbcloud_cluster.main.cluster_id
  cidr_block = "198.51.100.0/24"
}

# Allow CI/CD runners
resource "scylladbcloud_allowlist_rule" "ci" {
  cluster_id = scylladbcloud_cluster.main.cluster_id
  cidr_block = "192.0.2.0/24"
}
```

## Argument Reference

This resource supports the following arguments:

### Required

* `cluster_id` - (Required) The numeric ID of the ScyllaDB Cloud cluster to add the allowlist rule to.
* `cidr_block` - (Required, Forces new resource) The IPv4 CIDR block to allow access from. Must be in valid CIDR notation (e.g., `10.0.0.0/24` for a subnet or `10.0.0.1/32` for a single IP).

### Timeouts

`timeouts` block allows you to specify [timeouts](https://developer.hashicorp.com/terraform/language/resources/syntax#operation-timeouts) for certain operations:

* `create` - (Default `40m`) Time to wait for rule creation.
* `update` - (Default `40m`) Time to wait for rule updates.
* `delete` - (Default `90m`) Time to wait for rule deletion.

## Attribute Reference

This resource exports the following attributes in addition to the arguments above:

* `id` - The Terraform resource ID (same as `rule_id`).
* `rule_id` - The numeric ID of the allowlist rule in ScyllaDB Cloud.

## Import

Import is supported using the following syntax:

```shell
# An allowlist rule can be imported by specifying the numeric identifier.
terraform import scylladbcloud_allowlist_rule.example 123
```

## CIDR Notation Examples

| CIDR Block | Description |
|------------|-------------|
| `10.0.0.1/32` | Single IP address |
| `10.0.0.0/24` | 256 addresses (10.0.0.0 - 10.0.0.255) |
| `10.0.0.0/16` | 65,536 addresses (10.0.0.0 - 10.0.255.255) |
| `0.0.0.0/0` | All IPv4 addresses (not recommended for production) |

## Related Resources

* [scylladbcloud_cluster](cluster) - The cluster resource that must be created first
* [scylladbcloud_vpc_peering](vpc_peering) - Alternative private connectivity option
