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
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_tfe"></a> [tfe](#requirement\_tfe) | >= 0.26.1, < 1.0.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_tfe-notification_aws"></a> [tfe-notification\_aws](#module\_tfe-notification\_aws) | dhoppeIT/notification/tfe | ~> 0.1.0 |
| <a name="module_tfe-notification_terraform"></a> [tfe-notification\_terraform](#module\_tfe-notification\_terraform) | dhoppeIT/notification/tfe | ~> 0.1.0 |
| <a name="module_tfe-oauth_client"></a> [tfe-oauth\_client](#module\_tfe-oauth\_client) | dhoppeIT/oauth_client/tfe | ~> 0.2.0 |
| <a name="module_tfe-organization"></a> [tfe-organization](#module\_tfe-organization) | dhoppeIT/organization/tfe | ~> 0.3.0 |
| <a name="module_tfe-registry"></a> [tfe-registry](#module\_tfe-registry) | dhoppeIT/registry/tfe | ~> 0.1.0 |
| <a name="module_tfe-team"></a> [tfe-team](#module\_tfe-team) | dhoppeIT/team/tfe | ~> 0.1.1 |
| <a name="module_tfe-variable_aws"></a> [tfe-variable\_aws](#module\_tfe-variable\_aws) | dhoppeIT/variable/tfe | ~> 0.2.0 |
| <a name="module_tfe-variable_terraform"></a> [tfe-variable\_terraform](#module\_tfe-variable\_terraform) | dhoppeIT/variable/tfe | ~> 0.2.0 |
| <a name="module_tfe-workspace_aws"></a> [tfe-workspace\_aws](#module\_tfe-workspace\_aws) | dhoppeIT/workspace/tfe | ~> 0.2.0 |
| <a name="module_tfe-workspace_terraform"></a> [tfe-workspace\_terraform](#module\_tfe-workspace\_terraform) | dhoppeIT/workspace/tfe | ~> 0.2.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_github_token"></a> [github\_token](#input\_github\_token) | The token used to authenticate with GitHub | `string` | `null` | no |
| <a name="input_slack_webhook_url"></a> [slack\_webhook\_url](#input\_slack\_webhook\_url) | The destination URL used to send Slack notifications | `string` | `null` | no |

## Outputs

No outputs.

<!--- END_TF_DOCS --->

## Authors

Created and maintained by [Dennis Hoppe](https://github.com/dhoppeIT/).

## License

Apache 2 licensed. See [LICENSE](https://github.com/dhoppeIT/terraform-tfe-config/blob/main/LICENSE) for full details.
