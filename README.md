# terraform-tfe-config

Terraform module to manage the Terraform Cloud/Enterprise resources.

## Graph

![Graph](https://github.com/dhoppeIT/terraform-tfe-config/blob/main/rover.png)

## Usage

Copy and paste into your Terraform configuration, insert the variables and run ```terraform init```:

```hcl
module "tfe-organization" {
  source = "dhoppeIT/organization/tfe"

  name  = "dhoppeIT"
  email = "terraform@dhoppe.it"
}

module "tfe-oauth_client" {
  source = "dhoppeIT/oauth_client/tfe"

  organization     = module.tfe-organization.name
  api_url          = "https://api.github.com"
  http_url         = "https://github.com"
  oauth_token      = "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"
  service_provider = "github"
}

module "tfe-workspace" {
  source = "dhoppeIT/workspace/tfe"

  name         = "terraform"
  organization = module.tfe-organization.name
}

module "tfe-variable" {
  source = "dhoppeIT/variable/tfe"

  key          = "TFE_TOKEN"
  value        = module.tfe-oauth_client.oauth_token_id
  category     = "env"
  description  = "The token used to authenticate with Terraform Cloud/Enterprise"
  sensitive    = true
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
  url          = "https://hooks.slack.com/services/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"
  workspace_id = module.tfe-workspace.id
}

module "tfe-registry" {
  source = "dhoppeIT/registry/tfe"

  display_identifier = "dhoppeIT/terraform-tfe-registry"
  identifier         = "dhoppeIT/terraform-tfe-registry"
  oauth_token_id     = module.tfe-oauth_client.oauth_token_id
}
```

<!--- BEGIN_TF_DOCS --->
<!--- END_TF_DOCS --->

## Authors

Created and maintained by [Dennis Hoppe](https://github.com/dhoppeIT/).

## License

Apache 2 licensed. See [LICENSE](https://github.com/dhoppeIT/terraform-tfe-config/blob/main/LICENSE) for full details.
