resource "alicloud_vpc" "default" {
  name       = var.name
  cidr_block = "10.1.0.0/21"
}

resource "alicloud_vswitch" "default" {
  name              = var.name
  vpc_id            = alicloud_vpc.default.id
  cidr_block        = "10.1.1.0/24"
  availability_zone = data.alicloud_zones.default.zones[0].id
}

resource "alicloud_cs_managed_kubernetes" "default" {
  # reference link https://help.aliyun.com/document_detail/393596.html
  name_prefix               = var.name
  availability_zone         = data.alicloud_zones.default.zones[0].id
  worker_vswitch_ids        = [alicloud_vswitch.default.id]
  new_nat_gateway           = true
  worker_instance_types     = [data.alicloud_instance_types.default.instance_types[0].id]
  worker_number             = 2
  password                  = "PaSSwoRD123!"
  pod_cidr                  = "172.20.0.0/16"
  service_cidr              = "172.21.0.0/20"
  install_cloud_monitor     = false
  slb_internet_enabled      = true
  worker_disk_category      = "cloud_efficiency"
  worker_data_disk_category = "cloud_ssd"
  worker_data_disk_size     = 20
  addons {
    name   = "nginx-ingress-controller"
    config = "{\"IngressSlbNetworkType\":\"internet\",\"IngressSlbSpec\":\"slb.s2.small\"}"
  }
}
