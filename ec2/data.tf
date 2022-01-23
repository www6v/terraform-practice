data "aws_ami" "latest_amazonlinux1" {
  most_recent = true
  name_regex  = "amazonlinux1*"
  owners      = ["0123456789"]
}

data "aws_ami" "latest_amazonlinux2" {
  most_recent = true
  name_regex  = "amazonlinux2*"
  owners      = ["0123456789"]
}

data "aws_ami" "latest_centos" {
  most_recent = true
  name_regex  = "centos7-*"
  owners      = ["0123456789"]
}

data "aws_ami" "latest_debian" {
  most_recent = true
  name_regex  = "debian*"
  owners      = ["0123456789"]
}
