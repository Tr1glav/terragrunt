include "root" {
  path = find_in_parent_folders("root.hcl")
  expose = true
}
terraform {
  source = "git::ssh://git@github.com/Tr1glav/terragrunt-modules//evolution/network?ref=prod"
}

locals {
  environment = include.root.locals.environment
  hypervisor  = jsondecode(run_cmd("--terragrunt-quiet", "vault", "kv", "get", "-format=json", "infra/${local.environment}/hypervisor")).data.data
}

inputs = {
  project_id = local.hypervisor.project_id
  zone       = "ru.AZ-3"
  customer_id  = local.hypervisor.customer_id
  auth_key_id  = local.hypervisor.IAM_CLIENT_ID
  auth_secret  = local.hypervisor.IAM_CLIENT_SECRET
}
