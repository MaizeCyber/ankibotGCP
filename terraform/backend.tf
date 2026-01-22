terraform {
  backend "gcs" {
    bucket = "dramtic-potato-dumpling-serve"
    prefix = "terraform/state"
  }
  required_providers {
    archive = {
      source = "hashicorp/archive"
    }
  }
}