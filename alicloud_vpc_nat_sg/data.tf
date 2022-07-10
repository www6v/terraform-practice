data "alicloud_images" "images_ds" {
  owners      = "system"
  most_recent = true
  name_regex  = "^centos_7"
}

data "alicloud_resource_manager_resource_groups" "default" {
  name_regex = "default*"
}

