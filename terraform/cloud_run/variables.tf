variable "run_network" {}
variable "sa_email" {}
variable "run_name" {}
variable "container_name" {}
variable "run_subnetwork" {}
variable "local_ip" {}
variable "run_region" {}
variable "run_zone" {}
variable "project_id" {}
variable "instance_name" {}
variable "discord_app_id" {}

variable "discord_public_key" {
  type      = string
  ephemeral = true
  sensitive = true
}

variable "secret_trigger" {
  type        = string
  description = "Passed from GitHub Run ID to force secret updates"
}