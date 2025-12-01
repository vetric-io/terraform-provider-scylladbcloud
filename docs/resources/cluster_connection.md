---
page_title: "scylladbcloud_cluster_connection Resource - terraform-provider-scylladbcloud"
subcategory: "Networking"
description: |-
  Manages a cluster connection (e.g., AWS Transit Gateway) for a ScyllaDB Cloud cluster.
---

# scylladbcloud_cluster_connection (Resource)

Manages a cluster connection for a ScyllaDB Cloud cluster. Cluster connections enable advanced networking configurations such as AWS Transit Gateway attachments, providing connectivity between your ScyllaDB Cloud cluster and your cloud infrastructure.

-> **Note:** This resource is typically used for AWS Transit Gateway connections. For standard VPC peering, use the [`scylladbcloud_vpc_peering`](vpc_peering) resource instead.

~> **Important:** The configuration data varies depending on the connection type. Ensure you provide the correct data fields for your connection type.

## Example Usage

### AWS Transit Gateway VPC Attachment

```terraform
# Create AWS TGW VPC Attachment Connection for the specified cluster.

resource "scylladbcloud_cluster_connection" "aws_tgw" {
	cluster_id = 1337
	name       = "aws-tgw-test"
	cidrlist = ["10.201.0.0/16"]
	type = "AWS_TGW_ATTACHMENT"
	datacenter = "AWS_US_EAST_1"
	data = {
		tgwid  = "tgw-08461afa1119f390a"
 		ramarn = "arn:aws:ram:us-east-1:043400831220:resource-share/be3b0395-1782-47cb-9ae4-6d3517c6a721"
	}
}

output "scylladbcloud_cluster_connection_id" {
	value = scylladbcloud_cluster_connection.aws_tgw.id
}
```

## Argument Reference

This resource supports the following arguments:

### Required

* `cluster_id` - (Required) The numeric ID of the ScyllaDB Cloud cluster.
* `datacenter` - (Required, Forces new resource) The datacenter name of the cluster (e.g., `AWS_US_EAST_1`).
* `type` - (Required, Forces new resource) The type of connection. Currently supported types:
  * `transitGatewayVpcAttachment` - AWS Transit Gateway VPC Attachment
* `cidrlist` - (Required) A list of CIDR blocks to route to the cluster through this connection. These are the destination CIDRs that should be routed through the connection.
* `data` - (Required) A map of connection-specific configuration data. Keys must be lowercase. The required fields depend on the connection type:

  **For `transitGatewayVpcAttachment`:**
  * `transitgatewayid` - The ID of your AWS Transit Gateway
  * `transitgatewayarn` - The ARN of your AWS Transit Gateway (for cross-account access)

### Optional

* `name` - (Optional) A human-readable name for the connection.
* `status` - (Optional) The desired status of the connection. Valid values are `ACTIVE` (default) or `INACTIVE`.

### Timeouts

`timeouts` block allows you to specify [timeouts](https://developer.hashicorp.com/terraform/language/resources/syntax#operation-timeouts) for certain operations:

* `create` - (Default `40m`) Time to wait for connection creation.
* `update` - (Default `40m`) Time to wait for connection updates.
* `delete` - (Default `90m`) Time to wait for connection deletion.

## Attribute Reference

This resource exports the following attributes in addition to the arguments above:

* `id` - The Terraform resource ID (the connection ID).
* `external_id` - The cloud provider's resource ID for the connection (e.g., the Transit Gateway VPC Attachment ID on AWS).

## Import

Import is supported using the following syntax:

```shell
# An cluster connection can be imported by specifying the numeric identifier.
terraform import scylladbcloud_cluster_connection.example 123
```

## AWS Transit Gateway Setup

To use Transit Gateway with ScyllaDB Cloud, you need to:

1. **Create a Transit Gateway** in your AWS account
2. **Share the Transit Gateway** with ScyllaDB Cloud's AWS account using AWS Resource Access Manager (RAM)
3. **Create the cluster connection** using this resource
4. **Accept the VPC attachment** on your Transit Gateway
5. **Update Transit Gateway route tables** to route traffic to/from ScyllaDB

### Complete AWS Transit Gateway Example

```terraform
# 1. Create Transit Gateway
resource "aws_ec2_transit_gateway" "main" {
  description = "Main Transit Gateway"
  
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  
  tags = {
    Name = "scylladb-tgw"
  }
}

# 2. Share Transit Gateway with ScyllaDB Cloud
resource "aws_ram_resource_share" "scylla" {
  name                      = "scylladb-tgw-share"
  allow_external_principals = true
}

resource "aws_ram_resource_association" "tgw" {
  resource_share_arn = aws_ram_resource_share.scylla.arn
  resource_arn       = aws_ec2_transit_gateway.main.arn
}

resource "aws_ram_principal_association" "scylla" {
  resource_share_arn = aws_ram_resource_share.scylla.arn
  principal          = "123456789012"  # ScyllaDB Cloud AWS account ID
}

# 3. Create cluster connection
resource "scylladbcloud_cluster_connection" "tgw" {
  cluster_id = scylladbcloud_cluster.main.cluster_id
  datacenter = scylladbcloud_cluster.main.datacenter
  name       = "TGW Connection"
  type       = "transitGatewayVpcAttachment"
  
  cidrlist = ["10.0.0.0/16"]  # Your application CIDR
  
  data = {
    transitgatewayid  = aws_ec2_transit_gateway.main.id
    transitgatewayarn = aws_ec2_transit_gateway.main.arn
  }
  
  depends_on = [aws_ram_principal_association.scylla]
}

# 4. Accept the VPC attachment (if not auto-accepted)
data "aws_ec2_transit_gateway_vpc_attachment" "scylla" {
  filter {
    name   = "transit-gateway-id"
    values = [aws_ec2_transit_gateway.main.id]
  }
  
  filter {
    name   = "state"
    values = ["pendingAcceptance", "available"]
  }
  
  depends_on = [scylladbcloud_cluster_connection.tgw]
}

resource "aws_ec2_transit_gateway_vpc_attachment_accepter" "scylla" {
  transit_gateway_attachment_id = data.aws_ec2_transit_gateway_vpc_attachment.scylla.id
}

# 5. Add route to ScyllaDB cluster
resource "aws_ec2_transit_gateway_route" "scylla" {
  destination_cidr_block         = scylladbcloud_cluster.main.cidr_block
  transit_gateway_attachment_id  = data.aws_ec2_transit_gateway_vpc_attachment.scylla.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway.main.association_default_route_table_id
}
```

## Related Resources

* [scylladbcloud_cluster](cluster) - The cluster resource that must be created first
* [scylladbcloud_vpc_peering](vpc_peering) - Alternative connectivity using VPC peering
