variable "instance_network" {}
variable "sa_email" {}
variable "instance_name" {}
variable "container_name" {}
variable "instance_subnetwork" {}
variable "local_ip" {}

variable "discord_bot_token" {
  type      = string
  ephemeral = true
  sensitive = true
}

variable "openai_api_key" {
  type      = string
  ephemeral = true
  sensitive = true
}

variable "secret_trigger" {
  type        = string
  description = "Passed from GitHub Run ID to force secret updates"
}