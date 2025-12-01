---
page_title: "scylladbcloud_stack Resource - terraform-provider-scylladbcloud"
subcategory: "Internal"
description: |-
  Manages ScyllaDB Cloud stack resources for CloudFormation integration.
---

# scylladbcloud_stack (Resource)

~> **Internal Resource:** This resource is used for CloudFormation integration and is not intended for direct use. Use the standard resources like [`scylladbcloud_cluster`](cluster) for managing ScyllaDB Cloud resources.

Manages ScyllaDB Cloud stack resources for integration with AWS CloudFormation custom resources.

## Argument Reference

This resource supports the following arguments:

### Required

* `attributes` - (Required) A map of resource attributes for the stack operation. The specific attributes depend on the resource type being managed.

### Timeouts

`timeouts` block allows you to specify [timeouts](https://developer.hashicorp.com/terraform/language/resources/syntax#operation-timeouts) for certain operations:

* `create` - (Default `60s`) Time to wait for stack creation.
* `update` - (Default `60s`) Time to wait for stack updates.
* `delete` - (Default `60s`) Time to wait for stack deletion.

## Attribute Reference

This resource exports the following attributes:

* `id` - The stack resource ID.

## Related Resources

* [scylladbcloud_cluster](cluster) - For standard cluster management

