locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  environment      = local.environment_vars.locals.environment
  hypervisor       = jsondecode(run_cmd("--terragrunt-quiet", "vault", "kv", "get", "-format=json", "infra/${local.environment}/hypervisor")).data.data
  user             = jsondecode(run_cmd("--terragrunt-quiet", "vault", "kv", "get", "-format=json", "infra/${local.environment}/svc-init")).data.data
}

remote_state {
  backend = "s3"
  config = {
    bucket = "tfstate"
    key    = "${path_relative_to_include()}/tf.tfstate"
    region = "ru-central-1"
    endpoints = {
      s3 = "https://s3.cloud.ru"
    }
    use_lockfile   = true
    use_path_style = true

    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

inputs = {
  project_id  = local.hypervisor.project_id
  customer_id = local.hypervisor.customer_id
  auth_key_id = local.hypervisor.IAM_CLIENT_ID
  auth_secret = local.hypervisor.IAM_CLIENT_SECRET
  username    = local.user.username
  public_key  = local.user.public_key
}
