module "tfe-organization" {
  source = "dhoppeIT/organization/tfe"

  name                     = "dhoppeIT"
  email                    = "terraform@dhoppe.it"
  collaborator_auth_policy = "two_factor_mandatory"
}

module "tfe-oauth_client" {
  source = "dhoppeIT/oauth_client/tfe"

  organization     = module.tfe-organization.name
  api_url          = "https://api.github.com"
  http_url         = "https://github.com"
  oauth_token      = var.github_token
  service_provider = "github"
}

module "tfe-workspace" {
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

module "tfe-variable" {
  source = "dhoppeIT/variable/tfe"

  for_each = local.variables

  key          = each.value["key"]
  value        = each.value["value"]
  category     = each.value["category"]
  description  = each.value["description"]
  sensitive    = each.value["sensitive"]
  workspace_id = module.tfe-workspace.id
}

module "tfe-notification" {
  source = "dhoppeIT/notification/tfe"

  name             = "slack"
  enabled          = true
  destination_type = "slack"
  triggers = [
    "run:needs_attention",
    "run:errored"
  ]
  url          = var.slack_webhook_url
  workspace_id = module.tfe-workspace.id
}

module "tfe-registry" {
  source = "dhoppeIT/registry/tfe"

  for_each = local.modules

  display_identifier = each.value["display_identifier"]
  identifier         = each.value["identifier"]
  oauth_token_id     = module.tfe-oauth_client.oauth_token_id
}
