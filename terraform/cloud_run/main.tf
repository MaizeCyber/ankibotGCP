resource "google_cloud_run_v2_service" "ankibot" {
  name                = var.run_name
  location            = var.run_region
  ingress             = "INGRESS_TRAFFIC_INTERNAL_ONLY"
  deletion_protection = false # set to "true" in production

  template {
    service_account = var.sa_email
    scaling {
      max_instance_count = 1
      min_instance_count = 1
    }
    containers {
      image = var.container_name
      ports {
        container_port = 8080
      }
      resources {
        limits = {
          cpu    = "1"
          memory = "512Mi"
        }
      }
      env {
        name  = "DESKTOP_LOCAL_IP"
        value = var.local_ip
      }
      env {
        name = "DISCORD_BOT_TOKEN"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.discord_token.secret_id
            version = "latest"
          }
        }
      }
      env {
        name  = "DISCORD_APP_ID"
        value = var.discord_app_id
      }
      env {
        name  = "GOOGLE_CLOUD_PROJECT"
        value = var.project_id
      }
      env {
        name  = "GOOGLE_CLOUD_REGION"
        value = var.run_region
      }
      env {
        name  = "GOOGLE_CLOUD_ZONE"
        value = var.run_zone
      }
      env {
        name  = "INSTANCE_NAME"
        value = var.instance_name
      }
    }

    vpc_access {
      network_interfaces {
        network    = var.run_network
        subnetwork = var.run_subnetwork
      }
    }
  }
}