module "anki-desktop-vm" {
  source              = "./instance"
  instance_name       = "anki-desktop-1"
  instance_zone       = var.project_zone
  instance_type       = "e2-medium"
  instance_network    = google_compute_network.ankinetwork.id
  instance_subnetwork = google_compute_subnetwork.anki_internal_range.id
  sa_email            = google_service_account.anki_sa.email
}

module "ankibot-service" {
  source         = "./cloud_run"
  run_name       = "anki-desktop-1"
  project_id     = var.project_name
  run_region     = var.project_region
  run_network    = google_compute_network.ankinetwork.id
  run_subnetwork = google_compute_subnetwork.anki_internal_range.id
  sa_email       = google_service_account.anki_sa.email
  container_name = "docker.io/maizecyber/ankibot:gcpv2.0"
  local_ip       = module.anki-desktop-vm.local_ip
  instance_name     = "anki-desktop-1"
  run_zone          = var.project_zone
  discord_app_id = var.discord_app_id
  # Secrets
  discord_bot_token = var.discord_bot_token
  secret_trigger    = var.secret_trigger
}