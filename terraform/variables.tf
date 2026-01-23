variable "discord_public_key" {
  type      = string
  ephemeral = true # Matches the child module
  sensitive = true
}

variable "discord_app_id" {
  type = string
}

variable "secret_trigger" {
  type    = string
  default = "1"
}

variable "project_name" {
  type = string
}

variable "project_region" {
  type = string
}

variable "project_zone" {
  type = string
}