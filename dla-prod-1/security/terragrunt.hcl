include "root" {
  path = find_in_parent_folders("root.hcl")
  expose = true
}
terraform {
  source = "git::ssh://git@github.com/Tr1glav/terragrunt-modules//evolution/security?ref=prod"
}

inputs = {
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
