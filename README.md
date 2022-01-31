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
| <a name="module_tfe_notification_aws"></a> [tfe\_notification\_aws](#module\_tfe\_notification\_aws) | dhoppeIT/notification/tfe | ~> 0.1.0 |
| <a name="module_tfe_notification_hcloud"></a> [tfe\_notification\_hcloud](#module\_tfe\_notification\_hcloud) | dhoppeIT/notification/tfe | ~> 0.1.0 |
| <a name="module_tfe_notification_terraform"></a> [tfe\_notification\_terraform](#module\_tfe\_notification\_terraform) | dhoppeIT/notification/tfe | ~> 0.1.0 |
| <a name="module_tfe_oauth_client"></a> [tfe\_oauth\_client](#module\_tfe\_oauth\_client) | dhoppeIT/oauth_client/tfe | ~> 0.2.0 |
| <a name="module_tfe_organization"></a> [tfe\_organization](#module\_tfe\_organization) | dhoppeIT/organization/tfe | ~> 0.3.0 |
| <a name="module_tfe_registry"></a> [tfe\_registry](#module\_tfe\_registry) | dhoppeIT/registry/tfe | ~> 0.1.0 |
| <a name="module_tfe_team"></a> [tfe\_team](#module\_tfe\_team) | dhoppeIT/team/tfe | ~> 0.1.1 |
| <a name="module_tfe_variable_aws_dev"></a> [tfe\_variable\_aws\_dev](#module\_tfe\_variable\_aws\_dev) | dhoppeIT/variable/tfe | ~> 0.2.0 |
| <a name="module_tfe_variable_aws_prod"></a> [tfe\_variable\_aws\_prod](#module\_tfe\_variable\_aws\_prod) | dhoppeIT/variable/tfe | ~> 0.2.0 |
| <a name="module_tfe_variable_aws_stage"></a> [tfe\_variable\_aws\_stage](#module\_tfe\_variable\_aws\_stage) | dhoppeIT/variable/tfe | ~> 0.2.0 |
| <a name="module_tfe_variable_hcloud_dev"></a> [tfe\_variable\_hcloud\_dev](#module\_tfe\_variable\_hcloud\_dev) | dhoppeIT/variable/tfe | ~> 0.2.0 |
| <a name="module_tfe_variable_hcloud_prod"></a> [tfe\_variable\_hcloud\_prod](#module\_tfe\_variable\_hcloud\_prod) | dhoppeIT/variable/tfe | ~> 0.2.0 |
| <a name="module_tfe_variable_hcloud_stage"></a> [tfe\_variable\_hcloud\_stage](#module\_tfe\_variable\_hcloud\_stage) | dhoppeIT/variable/tfe | ~> 0.2.0 |
| <a name="module_tfe_variable_terraform"></a> [tfe\_variable\_terraform](#module\_tfe\_variable\_terraform) | dhoppeIT/variable/tfe | ~> 0.2.0 |
| <a name="module_tfe_workspace_aws"></a> [tfe\_workspace\_aws](#module\_tfe\_workspace\_aws) | dhoppeIT/workspace/tfe | ~> 0.2.0 |
| <a name="module_tfe_workspace_hcloud"></a> [tfe\_workspace\_hcloud](#module\_tfe\_workspace\_hcloud) | dhoppeIT/workspace/tfe | ~> 0.2.0 |
| <a name="module_tfe_workspace_terraform"></a> [tfe\_workspace\_terraform](#module\_tfe\_workspace\_terraform) | dhoppeIT/workspace/tfe | ~> 0.2.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_access_key_id"></a> [aws\_access\_key\_id](#input\_aws\_access\_key\_id) | The AWS access key to authenticate with Amazon Web Services | `string` | `null` | no |
| <a name="input_aws_secret_access_key"></a> [aws\_secret\_access\_key](#input\_aws\_secret\_access\_key) | The AWS secret key to authenticate with Amazon Web Services | `string` | `null` | no |
| <a name="input_github_token"></a> [github\_token](#input\_github\_token) | The token used to authenticate with GitHub | `string` | `null` | no |
| <a name="input_hcloud_token_dev"></a> [hcloud\_token\_dev](#input\_hcloud\_token\_dev) | The token used to authenticate with Hetzner Cloud | `string` | `null` | no |
| <a name="input_hcloud_token_prod"></a> [hcloud\_token\_prod](#input\_hcloud\_token\_prod) | The token used to authenticate with Hetzner Cloud | `string` | `null` | no |
| <a name="input_hcloud_token_stage"></a> [hcloud\_token\_stage](#input\_hcloud\_token\_stage) | The token used to authenticate with Hetzner Cloud | `string` | `null` | no |
| <a name="input_slack_webhook_url"></a> [slack\_webhook\_url](#input\_slack\_webhook\_url) | The destination URL used to send Slack notifications | `string` | `null` | no |

## Outputs

No outputs.

<!--- END_TF_DOCS --->

## Authors

Created and maintained by [Dennis Hoppe](https://github.com/dhoppeIT/).

## License

Apache 2 licensed. See [LICENSE](https://github.com/dhoppeIT/terraform-tfe-config/blob/main/LICENSE) for full details.
