variable "run_network" {}
variable "sa_email" {}
variable "run_name" {}
variable "container_name" {}
variable "run_subnetwork" {}
variable "local_ip" {}
variable "run_region" {}
variable "project_id" {}

variable "discord_bot_token" {
  type      = string
  ephemeral = true
  sensitive = true
}

variable "secret_trigger" {
  type        = string
  description = "Passed from GitHub Run ID to force secret updates"
}