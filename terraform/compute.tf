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
  container_name = "docker.io/maizecyber/ankibot:gcpv2.3"
  local_ip       = module.anki-desktop-vm.local_ip
  instance_name  = "anki-desktop-1"
  run_zone       = var.project_zone
  discord_app_id = var.discord_app_id
  # Secrets
  discord_bot_token = var.discord_bot_token
  secret_trigger    = var.secret_trigger
}

resource "google_cloudfunctions2_function" "instance_suspend_function" {
  name        = "instance-suspend"
  location    = var.project_region
  description = "Suspends instance if cloud run has not been used"

  build_config {
    runtime     = "python310"
    entry_point = "handle_eventarc_trigger"
    source {
      storage_source {
        bucket = google_storage_bucket.function_bucket.name
        object = google_storage_bucket_object.function_object.name
      }
    }
  }

  service_config {
    max_instance_count = 1
    available_memory   = "512M"
    timeout_seconds    = 60
    ingress_settings   = "ALLOW_INTERNAL_ONLY"

    environment_variables = {
      PROJECT_ZONE  = var.project_zone
      INSTANCE_NAME = "anki-desktop-1"
      PROJECT_NAME  = var.project_name
    }
    all_traffic_on_latest_revision = true
    service_account_email          = google_service_account.stop_function_sa.email
  }

  event_trigger {
    trigger_region        = var.project_region
    event_type            = "google.cloud.pubsub.topic.v1.messagePublished"
    pubsub_topic          = google_pubsub_topic.ankibot-idle-topic.id
    retry_policy          = "RETRY_POLICY_RETRY"
    service_account_email = google_service_account.eventarc.email
  }

}