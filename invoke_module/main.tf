module "tsj_demo" {
  # source = "git::https://jihulab.com/dhutsj/terraform-practice.git//alicloud_vpc_nat_sg?ref=main"
  source = "../alicloud_vpc_nat_sg"

  vpc_name = var.vpc_name
}