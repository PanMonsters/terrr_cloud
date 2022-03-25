terraform {
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "panbacket"
    region     = "us-east-1"
    key        = "devops-netology/Terraform-7.3/terraform.tfstate"
    access_key = <access_key>
    secret_key = <secret_key>
    
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}

