resource "google_secret_manager_secret" "discord_token" {
  secret_id = "DISCORD_BOT_TOKEN"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "discord_version" {
  secret                 = google_secret_manager_secret.discord_token.id
  secret_data_wo         = var.discord_bot_token
  secret_data_wo_version = var.secret_trigger
}

