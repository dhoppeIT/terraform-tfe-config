locals {
  modules = {
    "tfe-notification" = {
      display_identifier = "dhoppeIT/terraform-tfe-notification"
      identifier         = "dhoppeIT/terraform-tfe-notification"
    },
    "tfe-oauth_client" = {
      display_identifier = "dhoppeIT/terraform-tfe-oauth_client"
      identifier         = "dhoppeIT/terraform-tfe-oauth_client"
    },
    "tfe-organization" = {
      display_identifier = "dhoppeIT/terraform-tfe-organization"
      identifier         = "dhoppeIT/terraform-tfe-organization"
    },
    "tfe-registry" = {
      display_identifier = "dhoppeIT/terraform-tfe-registry"
      identifier         = "dhoppeIT/terraform-tfe-registry"
    },
    "tfe-variable" = {
      display_identifier = "dhoppeIT/terraform-tfe-variable"
      identifier         = "dhoppeIT/terraform-tfe-variable"
    },
    "tfe-workspace" = {
      display_identifier = "dhoppeIT/terraform-tfe-workspace"
      identifier         = "dhoppeIT/terraform-tfe-workspace"
    }
  }

  variables = {
    "github_token" = {
      key         = "github_token"
      value       = var.github_token
      category    = "terraform"
      description = "The token used to authenticate with GitHub"
      sensitive   = true
    },
    "slack_webhook_url" = {
      key         = "slack_webhook_url"
      value       = var.slack_webhook_url
      category    = "terraform"
      description = "The destination URL used to send Slack notifications"
      sensitive   = true
    }
  }
}
