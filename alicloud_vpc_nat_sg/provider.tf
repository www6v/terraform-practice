terraform {
  required_providers {
    alicloud = {
      source  = "aliyun/alicloud"
      version = "1.156.0"
    }
  }
}

provider "alicloud" {
  region = "cn-shanghai"
}
