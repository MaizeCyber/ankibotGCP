resource "google_cloud_run_v2_service" "ankibot" {
  name     = var.instance_name
  location = "us-east4"
  ingress = "INGRESS_TRAFFIC_INTERNAL_ONLY"
  deletion_protection = false # set to "true" in production

  template {
    service_account = var.sa_email
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
            secret = "DISCORD_BOT_TOKEN"
            version = "latest"
          }
        }
      }
      env {
        name = "OPENAI_API_KEY"
        value_source {
          secret_key_ref {
            secret = "OPENAI_API_KEY"
            version = "latest"
          }
        }
      }
    }

    vpc_access {
      network_interfaces {
        network    = var.instance_network
        subnetwork = var.instance_subnetwork
      }
    }
  }
}