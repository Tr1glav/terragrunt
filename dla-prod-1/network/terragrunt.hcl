include "root" {
  path = find_in_parent_folders("root.hcl")
  expose = true
}
terraform {
  source = "git::ssh://git@github.com/Tr1glav/terragrunt-modules//evolution/network?ref=prod"
}

inputs = {
  vpc = {
    "evo_vpc": {
      "evo_sg_subnet": {
        "subnet": "172.18.1.0/24",
        "zone": "ru.AZ-3"
      }
    }
  }
}
