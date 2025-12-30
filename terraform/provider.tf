provider "google" {
  project     = var.project_name
  region      = var.project_region
  zone        = var.project_zone
}

resource "google_project_service" "service_api" {
  service = "cloudresourcemanager.googleapis.com"
}