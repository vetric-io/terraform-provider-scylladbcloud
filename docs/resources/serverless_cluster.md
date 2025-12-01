---
page_title: "scylladbcloud_serverless_cluster Resource - terraform-provider-scylladbcloud"
subcategory: "Serverless"
description: |-
  Manages a ScyllaDB Cloud serverless cluster.
---

# scylladbcloud_serverless_cluster (Resource)

~> **Deprecated:** This resource is deprecated and will be removed in a future release of the provider. Consider using dedicated clusters with the [`scylladbcloud_cluster`](cluster) resource instead.

Manages a ScyllaDB Cloud serverless cluster. Serverless clusters provide an easy way to get started with ScyllaDB Cloud without managing infrastructure.

-> **Note:** Serverless clusters have limited configuration options compared to dedicated clusters. For production workloads with specific performance requirements, consider using the [`scylladbcloud_cluster`](cluster) resource.

## Example Usage

```terraform
# Create a serverless cluster.
resource "scylladbcloud_serverless_cluster" "example" {
	name = "My Cluster"
}

output "scylladbcloud_serverless_cluster_id" {
	value = scylladbcloud_serverless_cluster.example.id
}
```

### Free Tier Cluster

```terraform
resource "scylladbcloud_serverless_cluster" "free" {
  name      = "Free Tier Cluster"
  free_tier = true
}
```

### Serverless Cluster with Processing Units

```terraform
resource "scylladbcloud_serverless_cluster" "production" {
  name      = "Production Serverless"
  free_tier = false
  units     = 10
}
```

## Argument Reference

This resource supports the following arguments:

### Required

* `name` - (Required, Forces new resource) The name of the serverless cluster. Must be unique within your ScyllaDB Cloud account.

### Optional

* `free_tier` - (Optional, Forces new resource) Whether to create the cluster in the free tier. Defaults to `true`. Free tier clusters have limited resources but no cost.
* `enable_dns` - (Optional) Whether to enable DNS names (CNAME records) for seed nodes. Defaults to `true`.
* `units` - (Optional, Forces new resource) The number of processing units for the cluster. Only applicable when `free_tier` is `false`. Defaults to `0`.
* `hours` - (Optional, Forces new resource) The number of hours for the cluster to remain active. After this period, the cluster may be automatically terminated. Only applicable for temporary clusters. Defaults to `0` (no expiration).

### Timeouts

`timeouts` block allows you to specify [timeouts](https://developer.hashicorp.com/terraform/language/resources/syntax#operation-timeouts) for certain operations:

* `create` - (Default `40m`) Time to wait for cluster creation to complete.
* `update` - (Default `40m`) Time to wait for cluster updates to complete.
* `delete` - (Default `90m`) Time to wait for cluster deletion to complete.

## Attribute Reference

This resource exports the following attributes in addition to the arguments above:

* `id` - The Terraform resource ID (same as `cluster_id`).
* `cluster_id` - The numeric ID of the serverless cluster in ScyllaDB Cloud.

## Import

Import is supported using the following syntax:

```shell
# A serverless cluster can be imported by specifying the numeric identifier.
terraform import scylladbcloud_serverless_cluster.example 123
```

## Related Resources

* [scylladbcloud_serverless_bundle](../data-sources/serverless_bundle) - Retrieve the connection bundle for connecting to the cluster
* [scylladbcloud_cluster](cluster) - For dedicated cluster deployments with more configuration options
