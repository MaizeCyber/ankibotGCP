output "local_ip" {
  description = "The internal IP address of the compute instance"
  value       = google_compute_instance.anki_desktop.network_interface[0].network_ip
}