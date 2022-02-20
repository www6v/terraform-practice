variable "name" {
  default = "natGatewayExampleName"
}

resource "alicloud_vpc" "vpc" {
  vpc_name   = var.name
  cidr_block = "10.0.0.0/8"
}

data "alicloud_enhanced_nat_available_zones" "enhanced" {
}

resource "alicloud_vswitch" "enhanced" {
  vswitch_name = var.name
  zone_id      = data.alicloud_enhanced_nat_available_zones.enhanced.zones.0.zone_id
  cidr_block   = "10.10.0.0/20"
  vpc_id       = alicloud_vpc.vpc.id
}

resource "alicloud_nat_gateway" "enhanced" {
  depends_on       = [alicloud_vswitch.enhanced]
  vpc_id           = alicloud_vpc.vpc.id
  nat_gateway_name = var.name
  payment_type     = "PayAsYouGo"
  vswitch_id       = alicloud_vswitch.enhanced.id
  nat_type         = "Enhanced"
}

resource "alicloud_eip_address" "eip" {
  address_name         = "tf-eip"
  isp                  = "BGP"
  internet_charge_type = "PayByBandwidth"
  payment_type         = "PayAsYouGo"
}

resource "alicloud_eip_association" "eip_asso" {
  allocation_id = alicloud_eip_address.eip.id
  instance_type = "Nat"
  instance_id   = alicloud_nat_gateway.enhanced.id
}

resource "alicloud_snat_entry" "default" {
  depends_on        = [alicloud_eip_association.eip_asso]
  snat_table_id     = alicloud_nat_gateway.enhanced.snat_table_ids
  source_vswitch_id = alicloud_vswitch.enhanced.id
  snat_ip           = join(",", alicloud_eip_address.eip.*.ip_address)
}

resource "alicloud_security_group" "group" {
  name        = "foo"
  description = "foo"
  vpc_id      = alicloud_vpc.vpc.id
}

resource "alicloud_security_group_rule" "allow_all_tcp" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "22/22"
  priority          = 1
  security_group_id = alicloud_security_group.group.id
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_ess_scaling_group" "default" {
  min_size           = 1
  max_size           = 1
  desired_capacity   = 1
  scaling_group_name = var.ess_group_name
  # launch_template_id = alicloud_ecs_launch_template.default.id
  default_cooldown = 20
  vswitch_ids      = [alicloud_vswitch.enhanced.id]
  removal_policies = ["OldestInstance", "NewestInstance"]
}

# resource "alicloud_ecs_launch_template" "default" {
#   launch_template_name       = "tf"
#   description                = "Test For Terraform"
#   image_id                   = data.alicloud_images.images_ds.images.0.id
#   host_name                  = "aaabbb"
#   instance_charge_type       = "PostPaid"
#   instance_name              = "aaabbb"
#   instance_type              = "${data.alicloud_instance_types.default.instance_types.0.id}"
#   internet_charge_type       = "PayByBandwidth"
#   internet_max_bandwidth_in  = "5"
#   internet_max_bandwidth_out = "0"
#   io_optimized               = "none"
#   # key_pair_name                 = "key_pair_name"
#   network_type                  = "vpc"
#   security_enhancement_strategy = "Deactive"
#   security_group_ids            = [alicloud_security_group.group.id]
#   system_disk {
#     category             = "cloud_ssd"
#     description          = "Test For Terraform"
#     name                 = "tf_test_name"
#     size                 = "30"
#     delete_with_instance = "true"
#   }

#   template_tags = {
#     Create = "Terraform"
#     For    = "Test"
#   }
# }

resource "alicloud_ess_scaling_configuration" "default" {
  scaling_group_id  = alicloud_ess_scaling_group.default.id
  image_id          = data.alicloud_images.images_ds.images.0.id
  instance_type     = data.alicloud_instance_types.default.instance_types.0.id
  security_group_id = alicloud_security_group.group.id
  password          = "PassWOrd123!"
  user_data         = file("${path.module}/userdata.sh")
  force_delete      = true
  active            = true
}