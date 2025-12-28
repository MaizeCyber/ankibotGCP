resource "google_compute_instance" "anki_desktop" {
  name         = var.instance_name
  zone         = var.instance_zone
  machine_type = var.instance_type

  tags = ["anki_connect"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      }
  }
  network_interface {
    network = var.instance_network
    subnetwork = var.instance_subnetwork
  }

  metadata_startup_script = file("${path.module}/startup.sh")

  service_account {
    email  = var.sa_email
    scopes = ["cloud-platform"]
  }

  metadata = {
    shutdown-script = file("${path.module}/shutdown.sh")
  }
}
