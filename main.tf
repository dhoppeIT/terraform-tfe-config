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
}

module "tfe-organization" {
  source = "dhoppeIT/organization/tfe"

  name                                                    = "dhoppeIT"
  email                                                   = "terraform@dhoppe.it"
  collaborator_auth_policy                                = "two_factor_mandatory"
  send_passing_statuses_for_untriggered_speculative_plans = true
}

module "tfe-team" {
  source = "dhoppeIT/team/tfe"

  name                       = "owners"
  organization               = module.tfe-organization.name
  organization_membership_id = module.tfe-organization.id
}

module "tfe-oauth_client" {
  source = "dhoppeIT/oauth_client/tfe"

  organization     = module.tfe-organization.name
  api_url          = "https://api.github.com"
  http_url         = "https://github.com"
  oauth_token      = var.github_token
  service_provider = "github"
}

module "tfe-registry" {
  source = "dhoppeIT/registry/tfe"

  for_each = local.modules

  display_identifier = each.value["display_identifier"]
  identifier         = each.value["identifier"]
  oauth_token_id     = module.tfe-oauth_client.oauth_token_id
}
