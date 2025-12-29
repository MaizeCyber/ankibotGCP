provider "google" {
  project     = "ankiconnect-482403"
  region      = "us-east4"
  zone        = "us-east4-a"
}

resource "google_project_service" "service_api" {
  service = "cloudresourcemanager.googleapis.com"
}