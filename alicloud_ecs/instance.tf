variable "name" {
  default = "auto_provisioning_group"
}

resource "alicloud_vpc" "vpc" {
  name       = var.name
  cidr_block = "172.16.0.0/16"
}

resource "alicloud_security_group" "group" {
  name        = "foo"
  description = "foo"
  vpc_id      = alicloud_vpc.vpc.id
}

data "alicloud_zones" "default" {
  available_disk_category     = "cloud_efficiency"
  available_resource_creation = "VSwitch"
}

resource "alicloud_vswitch" "vswitch" {
  vpc_id            = alicloud_vpc.vpc.id
  cidr_block        = "172.16.0.0/24"
  zone_id           = data.alicloud_zones.default.zones[0].id
  vswitch_name      = var.name
}

resource "alicloud_instance" "instance" {

  security_groups   = alicloud_security_group.group.*.id

  # series III
  instance_type              = "ecs.n4.large"
  password = "PassWOrd123!"
  system_disk_category       = "cloud_efficiency"
  system_disk_name           = "system_disk"
  system_disk_description    = "system_disk"
  image_id                   = data.alicloud_images.images_ds.images.0.id
  instance_name              = "foo"
  vswitch_id                 = alicloud_vswitch.vswitch.id
  internet_max_bandwidth_out = 10
}
