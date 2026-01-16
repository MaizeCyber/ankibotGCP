resource "google_service_account" "anki_sa" {
  account_id   = "anki-server-sa"
  display_name = "Anki Server Service Account"
}

resource "google_project_iam_member" "anki_sa_secrets" {
  project = var.project_name
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.anki_sa.email}"
}

resource "google_project_iam_member" "anki_sa_run_admin" {
  project = var.project_name
  role    = "roles/run.admin"
  member  = "serviceAccount:${google_service_account.anki_sa.email}"
}

resource "google_project_iam_member" "anki_sa_vertex_admin" {
  project = var.project_name
  role    = "roles/aiplatform.user"
  member  = "serviceAccount:${google_service_account.anki_sa.email}"
}