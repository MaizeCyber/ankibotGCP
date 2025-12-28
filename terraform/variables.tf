variable "discord_bot_token" {
  type      = string
  ephemeral = true  # Matches the child module
  sensitive = true
}

variable "openai_api_key" {
  type      = string
  ephemeral = true
  sensitive = true
}

variable "secret_trigger" {
  type    = string
  default = "1"
}