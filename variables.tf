variable "aws_access_key_id" {
  type        = string
  default     = null
  description = "The AWS access key to authenticate with Amazon Web Services"
}

variable "aws_secret_access_key" {
  type        = string
  default     = null
  description = "The AWS secret key to authenticate with Amazon Web Services"
}

variable "github_token" {
  type        = string
  default     = null
  description = "The token used to authenticate with GitHub"
}

variable "hcloud_token_dev" {
  type        = string
  default     = null
  description = "The token used to authenticate with Hetzner Cloud"
}

variable "hcloud_token_stage" {
  type        = string
  default     = null
  description = "The token used to authenticate with Hetzner Cloud"
}

variable "hcloud_token_prod" {
  type        = string
  default     = null
  description = "The token used to authenticate with Hetzner Cloud"
}

variable "slack_webhook_url" {
  type        = string
  default     = null
  description = "The destination URL used to send Slack notifications"
}
