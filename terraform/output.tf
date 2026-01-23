output "cloud_run_url" {
  description = "The URL of the deployed Cloud Run service"
  value       = module.ankibot-service.service_url
}