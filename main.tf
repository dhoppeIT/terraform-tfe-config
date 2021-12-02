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

module "tfe-registry" {
  source = "dhoppeIT/registry/tfe"

  for_each = local.modules

  display_identifier = each.value["display_identifier"]
  identifier         = each.value["identifier"]
  oauth_token_id     = module.tfe-oauth_client.oauth_token_id
}
