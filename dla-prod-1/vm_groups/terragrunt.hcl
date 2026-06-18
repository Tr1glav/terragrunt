include "root" {
  path = find_in_parent_folders("root.hcl")
  expose = true
}
terraform {
  source = "git::ssh://git@github.com/Tr1glav/terragrunt-modules//evolution/vm_groups?ref=prod"
}

locals {
  environment = include.root.locals.environment
  hypervisor  = jsondecode(run_cmd("--terragrunt-quiet", "vault", "kv", "get", "-format=json", "infra/${local.environment}/hypervisor")).data.data
  user        = jsondecode(run_cmd("--terragrunt-quiet", "vault", "kv", "get", "-format=json", "infra/${local.environment}/svc-init")).data.data

}

inputs = {
  project_id = local.hypervisor.project_id  
  customer_id  = local.hypervisor.customer_id
  auth_key_id  = local.hypervisor.IAM_CLIENT_ID
  auth_secret  = local.hypervisor.IAM_CLIENT_SECRET
  username     = local.user.username
  public_key   = local.user.public_key

  
  vm_groups = {
    "router" = { 
      external_ip = true, 
      subnet = "172.18.1.0/24",
      cpu = 1, 
      ram = 2, 
      disk = 20, 
      flavor_type = "lowcost10", 
      sg = []
      vms = {
        "router-1" = { ip = "172.18.1.254" }
      }
    },
    "k3s"    =  { 
      external_ip = false, 
      subnet = "172.18.1.0/24", 
      cpu = 2, 
      ram = 4,
      disk = 40, 
      flavor_type = "lowcost10", 
      sg = ["k8s"] 
      vms = {
        "k3s-1" = { ip = "172.18.1.101" }
      }
    }
  }
}

