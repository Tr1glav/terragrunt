include "root" {
  path = find_in_parent_folders("root.hcl")
  expose = true
}
terraform {
  source = "git::ssh://git@github.com/Tr1glav/terragrunt-modules//evolution/security?ref=prod"
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

  sg_rules = {
    default = [
      { direction = "egress", protocol = "IP_PROTOCOL_ANY", port = "any", subnets = ["0.0.0.0/0"] },
      { direction = "ingress", protocol = "IP_PROTOCOL_ANY", port = "any", subnets = ["172.18.1.0/24"] }
    ]
    ssh = [
      { direction = "ingress", protocol = "IP_PROTOCOL_TCP", port = "22:22", subnets = ["0.0.0.0/0"] }
    ]
    https = [
      { direction = "ingress", protocol = "IP_PROTOCOL_TCP", port = "443:443", subnets = ["0.0.0.0/0"] }
    ]
    k8s = [
      { direction = "ingress", protocol = "IP_PROTOCOL_TCP", port = "6443:6443", subnets = ["0.0.0.0/0"] }
    ]
  }
}

