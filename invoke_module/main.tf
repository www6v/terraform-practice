module "tsj_demo" {
  source = "git::https://jihulab.com/dhutsj/terraform-practice.git//alicloud_vpc_nat_sg?ref=main"

  vpc_name = var.vpc_name
}