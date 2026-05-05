module "anki-desktop-vm" {
  source              = "./instance"
  instance_name       = "anki-desktop-1"
  instance_zone       = var.project_zone
  instance_type       = "e2-micro"
  instance_network    = google_compute_network.ankinetwork.id
  instance_subnetwork = google_compute_subnetwork.anki_internal_range.id
  sa_email            = google_service_account.anki_sa.email
  project_name        = var.project_name
  discord_app_id      = var.discord_app_id
  project_region      = var.project_region
}
