data "alicloud_vswitches" "default1" {
  name_regex = "shanghai-vpc-private-f"
}

data "alicloud_vswitches" "default2" {
  name_regex = "shanghai-vpc-private-g"
}

data "alicloud_ack_service" "open" {
  enable = "On"
  type   = "propayasgo"
}

data "alicloud_zones" "default" {
  available_resource_creation = "VSwitch"
}

data "alicloud_instance_types" "default" {
  availability_zone    = data.alicloud_zones.default.zones[0].id
  cpu_core_count       = 2
  memory_size          = 4
  kubernetes_node_role = "Worker"
}
