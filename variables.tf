variable "github_token" {
  type        = string
  default     = null
  description = "The token used to authenticate with GitHub"
}

variable "hcloud_token_dev" {
  type        = string
  default     = null
  description = "The token used to authenticate with Hetzner Cloud (dev)"
}

variable "hcloud_token_stage" {
  type        = string
  default     = null
  description = "The token used to authenticate with Hetzner Cloud (stage)"
}

variable "hcloud_token_prod" {
  type        = string
  default     = null
  description = "The token used to authenticate with Hetzner Cloud (prod)"
}

variable "slack_webhook_url" {
  type        = string
  default     = null
  description = "The destination URL used to send Slack notifications"
}
