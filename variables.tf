variable "github_token" {
  type        = string
  default     = null
  description = "The token used to authenticate with GitHub"
}

variable "slack_webhook_url" {
  type        = string
  default     = null
  description = "The destination URL used to send Slack notifications"
}
