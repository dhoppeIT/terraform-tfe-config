locals {
  variables_terraform = {
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

module "tfe-workspace_terraform" {
  source = "dhoppeIT/workspace/tfe"

  name              = "terraform"
  organization      = module.tfe-organization.name
  description       = "Provision of Terraform Cloud/Enterprise resources"
  queue_all_runs    = false
  terraform_version = "1.1.0"
  tag_names         = ["terraform"]
  identifier        = "dhoppeIT/terraform-tfe-config"
  branch            = "main"
  oauth_token_id    = module.tfe-oauth_client.oauth_token_id
}

module "tfe-variable_terraform" {
  source = "dhoppeIT/variable/tfe"

  for_each = local.variables_terraform

  key          = each.value["key"]
  value        = each.value["value"]
  category     = each.value["category"]
  description  = each.value["description"]
  sensitive    = each.value["sensitive"]
  workspace_id = module.tfe-workspace_terraform.id
}

module "tfe-notification_terraform" {
  source = "dhoppeIT/notification/tfe"

  name             = "slack"
  enabled          = true
  destination_type = "slack"
  triggers = [
    "run:needs_attention",
    "run:errored"
  ]
  url          = var.slack_webhook_url
  workspace_id = module.tfe-workspace_terraform.id
}
