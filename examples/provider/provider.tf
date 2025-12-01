terraform {
  required_providers {
    scylladbcloud = {
      source = "github.com/vetric-io/terraform-provider-scylladbcloud"
    }
  }
}

# Configuration-based authentication.
provider "scylladbcloud" {
  token = "..." # Replace with bearer token obtained from ScyllaDB Cloud
}
