resource "google_monitoring_alert_policy" "alert_policy" {
  display_name = "Ankibot Idle Alert"
  combiner     = "OR"

  conditions {
    display_name = "No traffic to Ankibot for 15 minutes"

    condition_absent {
      filter   = "resource.type = \"cloud_run_revision\" AND metric.type = \"run.googleapis.com/request_count\" AND resource.labels.service_name = \"anki-desktop-1\""
      duration = "900s" # 15 minutes

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_RATE"
      }
    }
  }

  notification_channels = [google_monitoring_notification_channel.pubsub_channel.name]
}