locals {
  variables_aws = {
    "slack_webhook_url" = {
      value       = var.slack_webhook_url
      category    = "terraform"
      description = "The destination URL used to send Slack notifications"
      sensitive   = true
    }
  }
}

module "tfe-workspace_aws" {
  source = "dhoppeIT/workspace/tfe"

  name              = "aws"
  organization      = module.tfe-organization.name
  description       = "Provision of Amazon Web Services resources"
  queue_all_runs    = true
  terraform_version = "1.1.3"
  tag_names         = ["aws"]
  identifier        = "dhoppeIT/terraform-aws-config"
  branch            = "main"
  oauth_token_id    = module.tfe-oauth_client.oauth_token_id
}

module "tfe-variable_aws" {
  source = "dhoppeIT/variable/tfe"

  for_each = local.variables_aws

  key                = each.key
  value              = each.value["value"]
  category           = each.value["category"]
  description        = each.value["description"]
  description_suffix = "(managed by Terraform)"
  sensitive          = each.value["sensitive"]
  workspace_id       = module.tfe-workspace_aws.id
}

module "tfe-notification_aws" {
  source = "dhoppeIT/notification/tfe"

  name             = "slack"
  enabled          = true
  destination_type = "slack"
  triggers = [
    "run:needs_attention",
    "run:errored"
  ]
  url          = var.slack_webhook_url
  workspace_id = module.tfe-workspace_aws.id
}
