terraform {
  required_providers {
    alicloud = {
      source  = "aliyun/alicloud"
      version = "1.152.0"
    }
  }
}

provider "alicloud" {
  access_key = "xxxxxxxx"
  secret_key = "xxxxxxxx"
  region     = "cn-shanghai"
}
