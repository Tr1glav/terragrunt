locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  environment      = local.environment_vars.locals.environment  
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