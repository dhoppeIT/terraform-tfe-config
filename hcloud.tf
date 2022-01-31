locals {
  variables_hcloud_dev = {
    "HCLOUD_TOKEN" = {
      value       = var.hcloud_token_dev
      category    = "env"
      description = "The token used to authenticate with Hetzner Cloud"
      sensitive   = true
    }
  }

  variables_hcloud_stage = {
    "HCLOUD_TOKEN" = {
      value       = var.hcloud_token_stage
      category    = "env"
      description = "The token used to authenticate with Hetzner Cloud"
      sensitive   = true
    }
  }

  variables_hcloud_prod = {
    "HCLOUD_TOKEN" = {
      value       = var.hcloud_token_prod
      category    = "env"
      description = "The token used to authenticate with Hetzner Cloud"
      sensitive   = true
    }
  }

  workspaces_hcloud = {
    "hcloud-dev" = {
      allow_destroy_plan = true
      terraform_version  = null
      tag_names          = ["hcloud", "dev"]
      identifier         = null
      branch             = null
    }
    "hcloud-stage" = {
      allow_destroy_plan = false
      terraform_version  = "~> 1.1.3"
      tag_names          = ["hcloud", "stage"]
      identifier         = "dhoppeIT/terraform-hcloud-config"
      branch             = "develop"
    }
    "hcloud-prod" = {
      allow_destroy_plan = false
      terraform_version  = "1.1.3"
      tag_names          = ["hcloud", "prod"]
      identifier         = "dhoppeIT/terraform-hcloud-config"
      branch             = "main"
    }
  }
}

module "tfe_workspace_hcloud" {
  source  = "dhoppeIT/workspace/tfe"
  version = "~> 0.2"

  for_each = local.workspaces_hcloud

  name               = each.key
  organization       = module.tfe_organization.name
  description        = "Provision of Hetzner Cloud resources"
  allow_destroy_plan = each.value["allow_destroy_plan"]
  terraform_version  = each.value["terraform_version"]
  tag_names          = each.value["tag_names"]
  identifier         = each.value["identifier"]
  branch             = each.value["branch"]
  oauth_token_id     = module.tfe_oauth_client.oauth_token_id
}

module "tfe_variable_hcloud_dev" {
  source  = "dhoppeIT/variable/tfe"
  version = "~> 0.2"

  for_each = local.variables_hcloud_dev

  key                = each.key
  value              = each.value["value"]
  category           = each.value["category"]
  description        = each.value["description"]
  description_suffix = "(managed by Terraform)"
  sensitive          = each.value["sensitive"]
  workspace_id       = module.tfe_workspace_hcloud["hcloud-dev"].id
}

module "tfe_variable_hcloud_stage" {
  source  = "dhoppeIT/variable/tfe"
  version = "~> 0.2"

  for_each = local.variables_hcloud_stage

  key                = each.key
  value              = each.value["value"]
  category           = each.value["category"]
  description        = each.value["description"]
  description_suffix = "(managed by Terraform)"
  sensitive          = each.value["sensitive"]
  workspace_id       = module.tfe_workspace_hcloud["hcloud-stage"].id
}

module "tfe_variable_hcloud_prod" {
  source  = "dhoppeIT/variable/tfe"
  version = "~> 0.2"

  for_each = local.variables_hcloud_prod

  key                = each.key
  value              = each.value["value"]
  category           = each.value["category"]
  description        = each.value["description"]
  description_suffix = "(managed by Terraform)"
  sensitive          = each.value["sensitive"]
  workspace_id       = module.tfe_workspace_hcloud["hcloud-prod"].id
}

module "tfe_notification_hcloud" {
  source  = "dhoppeIT/notification/tfe"
  version = "~> 0.1"

  for_each = local.workspaces_hcloud

  name             = "slack"
  enabled          = each.key == "hcloud-dev" ? false : true
  destination_type = "slack"
  triggers = [
    "run:needs_attention",
    "run:errored"
  ]
  url          = var.slack_webhook_url
  workspace_id = module.tfe_workspace_hcloud[each.key].id
}
