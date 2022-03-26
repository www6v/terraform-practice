data "alicloud_images" "images_ds" {
  owners      = "system"
  most_recent = true
  name_regex  = "^centos_7"
}