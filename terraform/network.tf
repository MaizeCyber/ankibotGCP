resource "google_compute_network" "ankinetwork" {
  name = "ankinetwork"
  # RESOURCE properties go here
  auto_create_subnetworks = "false"
}

resource "google_compute_firewall" "allow_client_traffic" {
  name = "allow-client-traffic"
  # RESOURCE properties go here
  network = google_compute_network.ankinetwork.self_link
  target_tags = ["anki-connect"]
  allow {
    protocol = "tcp"
    ports    = ["8765"]
    }
  allow {
    protocol = "icmp"
    }
  source_ranges = ["10.0.0.0/24"]
}

resource "google_compute_subnetwork" "anki_internal_range" {
  name          = "anki-desktop-internal-range"
  ip_cidr_range = "10.2.0.0/16"
  region        = "us-east4"
  network       = google_compute_network.ankinetwork.self_link
}

resource "google_compute_router" "router" {
  name    = "my-router"
  region  = google_compute_subnetwork.anki_internal_range.region
  network = google_compute_network.ankinetwork.id

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "nat" {
  name                               = "my-router-nat"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}