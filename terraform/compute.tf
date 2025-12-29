module "anki-desktop-vm" {
  source           = "./instance"
  instance_name    = "anki-desktop-1"
  instance_zone    = "us-east4-a"
  instance_type     = "e2-small"
  instance_network = google_compute_network.ankinetwork.id
  instance_subnetwork = google_compute_subnetwork.anki_internal_range.id
  sa_email = google_service_account.anki_sa.email
}

module "ankibot-service" {
  source           = "./cloud_run"
  instance_name    = "anki-desktop-1"
  instance_network = google_compute_network.ankinetwork.id
  instance_subnetwork = google_compute_subnetwork.anki_internal_range.id
  sa_email = google_service_account.anki_sa.email
  container_name = "docker.io/maizecyber/ankibot:gcp"
  local_ip = module.anki-desktop-vm.local_ip
  # Secrets
  discord_bot_token = var.discord_bot_token
  openai_api_key    = var.openai_api_key
  secret_trigger    = var.secret_trigger
}

resource "google_service_account" "anki_sa" {
  account_id   = "anki-server-sa"
  display_name = "Anki Server Service Account"
}

resource "google_project_iam_member" "anki_sa_secrets" {
  project = "ankiconnect-482403"
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.anki_sa.email}"
}

resource "google_project_iam_member" "anki_sa_run_admin" {
  project = "ankiconnect-482403"
  role    = "roles/run.admin"
  member  = "serviceAccount:${google_service_account.anki_sa.email}"
}



