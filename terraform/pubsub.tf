resource "google_pubsub_topic" "ankibot_idle_topic" {
  name = "ankibot-idle-alert-topic"
}

resource "google_monitoring_notification_channel" "pubsub_channel" {
  display_name = "PubSub Shutdown Channel"
  type         = "pubsub"
  labels = {
    topic = google_pubsub_topic.ankibot_idle_topic.id
  }
}