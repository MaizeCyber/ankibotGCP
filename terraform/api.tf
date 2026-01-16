resource "google_project_service" "service_api" {
  project = var.project_name
  service = "cloudresourcemanager.googleapis.com"
}

resource "google_project_service" "cloud_run_api" {
  project = var.project_name
  service = "run.googleapis.com"
}

resource "google_project_service" "compute_engine_api" {
  project = var.project_name
  service = "compute.googleapis.com"
}

resource "google_project_service" "vertex_ai" {
  project = var.project_name
  service = "aiplatform.googleapis.com"
}
