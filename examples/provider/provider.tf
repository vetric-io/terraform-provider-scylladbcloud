terraform {
  required_providers {
    scylladbcloud = {
      source  = "vetric-io/scylladbcloud"
      version = "~> 1.0"
    }
  }
}

# Configuration-based authentication.
provider "scylladbcloud" {
  token = "..." # Replace with bearer token obtained from ScyllaDB Cloud
}
