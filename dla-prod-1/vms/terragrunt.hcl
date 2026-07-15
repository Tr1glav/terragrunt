include "root" {
  path = find_in_parent_folders("root.hcl")
  expose = true
}
terraform {
  source = "git::ssh://git@github.com/Tr1glav/terragrunt-modules//evolution/vms?ref=prod"
}

inputs = {
  vms = {
    "router-1" = { external_ip = true, ip = "172.18.1.254", subnet = "172.18.1.0/24", cpu = 1, ram = 2, disk = 20, flavor_type = "lowcost10", sg = [] }
  }
}
