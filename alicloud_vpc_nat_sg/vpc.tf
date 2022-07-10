variable "natname" {
  default = "natGatewayExampleName"
}

variable "swname" {
  default = "vswitchExampleName"
}

resource "alicloud_vpc" "vpc" {
  vpc_name   = var.vpc_name
  cidr_block = "10.0.0.0/8"
}

data "alicloud_enhanced_nat_available_zones" "enhanced" {
}

resource "alicloud_vswitch" "enhanced" {
  vswitch_name = var.swname
  zone_id      = data.alicloud_enhanced_nat_available_zones.enhanced.zones.0.zone_id
  cidr_block   = "10.10.0.0/20"
  vpc_id       = alicloud_vpc.vpc.id
}

resource "alicloud_nat_gateway" "enhanced" {
  depends_on       = [alicloud_vswitch.enhanced]
  vpc_id           = alicloud_vpc.vpc.id
  nat_gateway_name = var.natname
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

resource "alicloud_instance" "instance" {

  security_groups = alicloud_security_group.group.*.id

  # series III
  instance_type           = "ecs.n4.large"
  password                = "PassWOrd123!"
  system_disk_category    = "cloud_efficiency"
  system_disk_name        = "system_disk"
  system_disk_description = "system_disk"
  image_id                = data.alicloud_images.images_ds.images.0.id
  instance_name           = "foo"
  vswitch_id              = alicloud_vswitch.enhanced.id
  user_data               = file("${path.module}/userdata.sh")
  # Setting "internet_max_bandwidth_out" larger than 0 can allocate a public ip address for an instance.
  # internet_max_bandwidth_out = 10
}
