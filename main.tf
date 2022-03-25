# Образ
data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2004-lts"
}

# Модули
module "vpc" {
  source  = "hamnsk/vpc/yandex"
  version = "0.5.0"
  description = "managed by terraform"
  create_folder = length(var.yc_folder_id) > 0 ? false : true
  name = terraform.workspace
  subnets = local.vpc_subnets[terraform.workspace]
}
# Локальные переменные для count иfor_each
locals {
    vm_cores = {
    stage = 2
    prod = 2
  }
    vm_platform_id = {
    stage = "standard-v1"
    prod = "standard-v2"
  }
    vm_count = {
    stage = 1
    prod = 2
  }
    vm_for_each_map = {
    stage = toset(["s1"])
    prod  = toset(["p1", "p2"])
  }
    vpc_subnets = {
    stage = [
      {
        zone           = "ru-central1-a"
        v4_cidr_blocks = ["10.128.0.0/24"]
      },
    ]
    prod = [
      {
        zone           = "ru-central1-a"
        v4_cidr_blocks = ["10.128.1.0/24"]
      },
    ]
  }
}


# Виртуальная машина
resource "yandex_compute_instance" "vm" {
  name = "${format("web-%03d", count.index + 1)}"
  count       = local.vm_count[terraform.workspace]
  folder_id = module.vpc.folder_id
  platform_id = local.vm_platform_id[terraform.workspace]

  resources {
    cores         = local.vm_cores[terraform.workspace]
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      type     = "network-hdd"
      size     = "15"
    }
  }

  network_interface {
    subnet_id = module.vpc.subnet_ids[0]
    nat       = true
    ipv6      = false
 }

  metadata = {
    ssh-keys = "ubuntu:${file("/home/panmonster/.ssh/id_rsa.pub")}"
  }
}

# Виртуальная машина
resource "yandex_compute_instance" "vm_for_each" {

  lifecycle {
    create_before_destroy = true
  }
  
  name = "${each.key}"
  for_each       = local.vm_for_each_map[terraform.workspace]
  folder_id = module.vpc.folder_id
  platform_id = local.vm_platform_id[terraform.workspace]

  resources {
    cores         = local.vm_cores[terraform.workspace]
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      type     = "network-hdd"
      size     = "15"
    }
  }

  network_interface {
    subnet_id = module.vpc.subnet_ids[0]
    nat       = true
    ipv6      = false
 }

  metadata = {
    ssh-keys = "ubuntu:${file("/home/panmonster/.ssh/id_rsa.pub")}"
  }
}

