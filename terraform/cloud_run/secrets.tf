resource "google_secret_manager_secret" "discord_token" {
  secret_id = "DISCORD_BOT_TOKEN"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret" "openai_key" {
  secret_id = "OPENAI_API_KEY"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "discord_version" {
  secret         = google_secret_manager_secret.discord_token.id
  secret_data_wo = var.discord_bot_token
  secret_data_wo_version = var.secret_trigger
}

resource "google_secret_manager_secret_version" "openai_version" {
  secret         = google_secret_manager_secret.openai_key.id
  secret_data_wo = var.openai_api_key
  secret_data_wo_version = var.secret_trigger
}

resource "google_secret_manager_secret_iam_member" "ankibot_secret_access" {
  for_each  = toset([
    google_secret_manager_secret.discord_token.id,
    google_secret_manager_secret.openai_key.id
  ])
  secret_id = each.value
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${var.sa_email}"
}

