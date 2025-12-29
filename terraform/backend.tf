terraform {
  backend "gcs" {
    bucket  = "dramtic-potato-dumpling-serve"
    prefix  = "terraform/state"
  }
}