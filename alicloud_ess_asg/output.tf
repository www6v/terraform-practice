output "vpc_id" {
  value = alicloud_vpc.vpc.id
}

output "path" {
  value = "${path.module}/userdata.sh"
}