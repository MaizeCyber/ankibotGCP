resource "google_storage_bucket" "gcs_backup_bucket" {
  name           = "dramtic-potato-dumpling-serve"
  location       = "US"
  storage_class  = "STANDARD"
  uniform_bucket_level_access = true
}

terraform {
  backend "gcs" {
    bucket  = "dramtic-potato-dumpling-serve"
    prefix  = "terraform/state"
  }
}