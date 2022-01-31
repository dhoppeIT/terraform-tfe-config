locals {
  # FIXME
  variables_aws_dev = {
    "AWS_ACCESS_KEY_ID" = {
      value       = var.aws_access_key_id
      category    = "env"
      description = "The AWS access key to authenticate with Amazon Web Services"
      sensitive   = false
    },
    "AWS_SECRET_ACCESS_KEY" = {
      value       = var.aws_secret_access_key
      category    = "env"
      description = "The AWS secret key to authenticate with Amazon Web Services"
      sensitive   = true
    }
  }

  # FIXME
  variables_aws_stage = {
    "AWS_ACCESS_KEY_ID" = {
      value       = var.aws_access_key_id
      category    = "env"
      description = "The AWS access key to authenticate with Amazon Web Services"
      sensitive   = false
    },
    "AWS_SECRET_ACCESS_KEY" = {
      value       = var.aws_secret_access_key
      category    = "env"
      description = "The AWS secret key to authenticate with Amazon Web Services"
      sensitive   = true
    }
  }

  # FIXME
  variables_aws_prod = {
    "AWS_ACCESS_KEY_ID" = {
      value       = var.aws_access_key_id
      category    = "env"
      description = "The AWS access key to authenticate with Amazon Web Services"
      sensitive   = false
    },
    "AWS_SECRET_ACCESS_KEY" = {
      value       = var.aws_secret_access_key
      category    = "env"
      description = "The AWS secret key to authenticate with Amazon Web Services"
      sensitive   = true
    }
  }

  workspaces_aws = {
    "aws-dev" = {
      allow_destroy_plan = true
      terraform_version  = null
      tag_names          = ["aws", "dev"]
      identifier         = null
      branch             = null
    }
    "aws-stage" = {
      allow_destroy_plan = false
      terraform_version  = "~> 1.1.3"
      tag_names          = ["aws", "stage"]
      identifier         = "dhoppeIT/terraform-aws-config"
      branch             = "develop"
    }
    "aws-prod" = {
      allow_destroy_plan = false
      terraform_version  = "1.1.3"
      tag_names          = ["aws", "prod"]
      identifier         = "dhoppeIT/terraform-aws-config"
      branch             = "main"
    }
  }
}

module "tfe_workspace_aws" {
  source  = "dhoppeIT/workspace/tfe"
  version = "~> 0.2"

  for_each = local.workspaces_aws

  name               = each.key
  organization       = module.tfe_organization.name
  description        = "Provision of Amazon Web Services resources"
  allow_destroy_plan = each.value["allow_destroy_plan"]
  terraform_version  = each.value["terraform_version"]
  tag_names          = each.value["tag_names"]
  identifier         = each.value["identifier"]
  branch             = each.value["branch"]
  oauth_token_id     = module.tfe_oauth_client.oauth_token_id
}

module "tfe_variable_aws_dev" {
  source  = "dhoppeIT/variable/tfe"
  version = "~> 0.2"

  for_each = local.variables_aws_dev

  key                = each.key
  value              = each.value["value"]
  category           = each.value["category"]
  description        = each.value["description"]
  description_suffix = "(managed by Terraform)"
  sensitive          = each.value["sensitive"]
  workspace_id       = module.tfe_workspace_aws["aws-dev"].id
}

module "tfe_variable_aws_stage" {
  source  = "dhoppeIT/variable/tfe"
  version = "~> 0.2"

  for_each = local.variables_aws_stage

  key                = each.key
  value              = each.value["value"]
  category           = each.value["category"]
  description        = each.value["description"]
  description_suffix = "(managed by Terraform)"
  sensitive          = each.value["sensitive"]
  workspace_id       = module.tfe_workspace_aws["aws-stage"].id
}

module "tfe_variable_aws_prod" {
  source  = "dhoppeIT/variable/tfe"
  version = "~> 0.2"

  for_each = local.variables_aws_prod

  key                = each.key
  value              = each.value["value"]
  category           = each.value["category"]
  description        = each.value["description"]
  description_suffix = "(managed by Terraform)"
  sensitive          = each.value["sensitive"]
  workspace_id       = module.tfe_workspace_aws["aws-prod"].id
}

module "tfe_notification_aws" {
  source  = "dhoppeIT/notification/tfe"
  version = "~> 0.1"

  for_each = local.workspaces_aws

  name             = "slack"
  enabled          = each.key == "aws-dev" ? false : true
  destination_type = "slack"
  triggers = [
    "run:needs_attention",
    "run:errored"
  ]
  url          = var.slack_webhook_url
  workspace_id = module.tfe_workspace_aws[each.key].id
}
