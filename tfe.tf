module "tfe-workspace_terraform" {
  source = "dhoppeIT/workspace/tfe"

  name              = "terraform"
  organization      = module.tfe-organization.name
  description       = "Provision of Terraform Cloud/Enterprise resources"
  queue_all_runs    = false
  terraform_version = "1.0.11"
  tag_names         = ["terraform"]
  identifier        = "dhoppeIT/terraform-tfe-config"
  branch            = "main"
  oauth_token_id    = module.tfe-oauth_client.oauth_token_id
}

module "tfe-variable_terraform" {
  source = "dhoppeIT/variable/tfe"

  for_each = local.variables

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
