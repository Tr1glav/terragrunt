https://github.com/cloud-ru/evo-terraform
https://cloud.ru/docs/terraform-evolution/ug/topics/quickstart

cd \
  && curl -L --create-dirs -o .terraform.d/plugins/cloud.ru/cloudru/cloud/2.0.2/linux_amd64/terraform-provider-cloud_2.0.2_linux_amd64 \
  https://github.com/CLOUDdotRu/evo-terraform/releases/download/2.0.2/terraform-provider-cloud_2.0.2_linux_amd64 \
  && chmod +x .terraform.d/plugins/cloud.ru/cloudru/cloud/2.0.2/linux_amd64/terraform-provider-cloud_2.0.2_linux_amd64


(venv) [user@work-pc security]$ cat ~/.terraformrc 
provider_installation {
  network_mirror {
    url = "https://terraform-mirror.yandexcloud.net/"
    include = ["registry.terraform.io/*/*"]
  }
  
  filesystem_mirror {
    path = "/home/user/.terraform.d/plugins"
    include = ["cloud.ru/*/*"] 
  }
  
  direct {
    exclude = ["cloud.ru/*/*"] 
  }
}