locals {
  variables_terraform = {
    "github_token" = {
      value       = var.github_token
      category    = "terraform"
      description = "The token used to authenticate with GitHub"
      sensitive   = true
    },
    "slack_webhook_url" = {
      value       = var.slack_webhook_url
      category    = "terraform"
      description = "The destination URL used to send Slack notifications"
      sensitive   = true
    },
    "TFE_TOKEN" = {
      value       = module.tfe_team.token
      category    = "env"
      description = "The token used to authenticate with Terraform Cloud/Enterprise"
      sensitive   = true
    }
  }
}

module "tfe_workspace_terraform" {
  source  = "dhoppeIT/workspace/tfe"
  version = "~> 0.2.0"

  name              = "terraform"
  organization      = module.tfe_organization.name
  description       = "Provision of Terraform Cloud/Enterprise resources"
  queue_all_runs    = false
  terraform_version = "1.1.3"
  tag_names         = ["terraform"]
  identifier        = "dhoppeIT/terraform-tfe-config"
  branch            = "main"
  oauth_token_id    = module.tfe_oauth_client.oauth_token_id
}

module "tfe_variable_terraform" {
  source  = "dhoppeIT/variable/tfe"
  version = "~> 0.2.0"

  for_each = local.variables_terraform

  key                = each.key
  value              = each.value["value"]
  category           = each.value["category"]
  description        = each.value["description"]
  description_suffix = "(managed by Terraform)"
  sensitive          = each.value["sensitive"]
  workspace_id       = module.tfe_workspace_terraform.id
}

module "tfe_notification_terraform" {
  source  = "dhoppeIT/notification/tfe"
  version = "~> 0.1.0"

  name             = "slack"
  enabled          = true
  destination_type = "slack"
  triggers = [
    "run:needs_attention",
    "run:errored"
  ]
  url          = var.slack_webhook_url
  workspace_id = module.tfe_workspace_terraform.id
}
