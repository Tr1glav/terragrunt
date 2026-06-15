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
  customer_id  = local.hypervisor.customer_id
  auth_key_id  = local.hypervisor.IAM_CLIENT_ID
  auth_secret  = local.hypervisor.IAM_CLIENT_SECRET

  vpc = {
    "evo_vpc": {
      "evo_sg_subnet": {
        "subnet": "172.18.1.0/24",
        "zone": "ru.AZ-3"
      },
      "evo_sg_subnet_2": {
        "subnet": "172.18.2.0/24",
        "zone": "ru.AZ-2"
      }
    }
  }
}
