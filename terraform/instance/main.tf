resource "google_compute_instance" "anki_desktop" {
  name         = var.instance_name
  zone         = var.instance_zone
  machine_type = var.instance_type

  allow_stopping_for_update = true
  tags                      = ["anki-connect", "anki-ssh"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }
  network_interface {
    network    = var.instance_network
    subnetwork = var.instance_subnetwork
  }

  metadata_startup_script = file("${path.module}/startup.sh")

  service_account {
    email  = var.sa_email
    scopes = ["cloud-platform"]
  }
  attached_disk {
    source      = google_compute_disk.anki_data.id
    device_name = google_compute_disk.anki_data.name
    mode        = "READ_WRITE"
  }

}

resource "google_compute_disk" "anki_data" {
  name = "anki-data-disk"
  size = 50 # GB
  zone = var.instance_zone
  type = "pd-ssd"
}