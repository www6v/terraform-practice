data "alicloud_images" "images_ds" {
  owners      = "system"
  most_recent = true
  name_regex  = "^centos_7"
}

data "alicloud_zones" "default" {
  available_resource_creation = "Instance"
}

data "alicloud_instance_types" "default" {
  availability_zone = data.alicloud_zones.default.zones[0].id
  cpu_core_count    = 1
  memory_size       = 2
}
