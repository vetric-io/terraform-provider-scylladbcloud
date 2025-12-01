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
