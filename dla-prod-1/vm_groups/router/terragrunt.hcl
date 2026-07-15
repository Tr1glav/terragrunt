include "root" {
  path = find_in_parent_folders("root.hcl")
  expose = true
}
terraform {
  source = "git::ssh://git@github.com/Tr1glav/terragrunt-modules//evolution/vm_groups?ref=prod"
}

inputs = {
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
  }
}
