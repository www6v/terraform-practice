resource "alicloud_log_project" "default" {
  name        = "tsjalb"
  description = "created by terraform"
}

resource "alicloud_log_store" "default" {
  project               = alicloud_log_project.default.name
  name                  = "alblog"
  shard_count           = 3
  auto_split            = true
  max_split_shard_count = 60
  append_meta           = true
}

resource "alicloud_log_store_index" "example" {
  project  = alicloud_log_project.default.name
  logstore = alicloud_log_store.default.name
  full_text {
    case_sensitive = false
    token          = " #$%^*\r\n    "
  }
  field_search {
    name             = "alblog"
    enable_analytics = true
  }
}

resource "alicloud_alb_load_balancer" "default" {
  vpc_id                 = alicloud_vpc.vpc.id
  address_type           = "Internet"
  address_allocated_mode = "Fixed"
  load_balancer_name     = "tsj_demo_alb"
  load_balancer_edition  = "Standard"
  resource_group_id      = data.alicloud_resource_manager_resource_groups.default.groups.0.id
  load_balancer_billing_config {
    pay_type = "PayAsYouGo"
  }
  tags = {
    Environment = "demo",
    Product = "nginx_alb_service"
  }
  zone_mappings {
    vswitch_id = alicloud_vswitch.enhanced.id
    zone_id    = data.alicloud_enhanced_nat_available_zones.enhanced.zones.0.zone_id
  }
  modification_protection_config {
    status = "NonProtection"
  }
  access_log_config {
    log_project = alicloud_log_project.default.name
    log_store   = alicloud_log_store.default.name
  }
}

resource "alicloud_alb_server_group" "default" {
  protocol          = "HTTP"
  vpc_id            = alicloud_vpc.vpc.id
  server_group_name = "tsj_nginx"
  resource_group_id = data.alicloud_resource_manager_resource_groups.default.groups.0.id
  health_check_config {
    health_check_connect_port = "80"
    health_check_enabled      = true
    health_check_host         = "tsj-test.com"
    health_check_codes        = ["http_2xx", "http_3xx"]
    health_check_http_version = "HTTP1.1"
    health_check_interval     = "2"
    health_check_method       = "GET"
    health_check_path         = "/"
    health_check_protocol     = "HTTP"
    health_check_timeout      = 5
    healthy_threshold         = 3
    unhealthy_threshold       = 3
  }
  sticky_session_config {
    sticky_session_enabled = "false"
  }
  servers {
    description = "server1"
    port        = 80
    server_id = alicloud_instance.instance.id
    server_ip   = alicloud_instance.instance.private_ip
    server_type = "Ecs"
    weight      = 100
  }
}

resource "alicloud_alb_listener" "example" {
  load_balancer_id     = alicloud_alb_load_balancer.default.id
  listener_protocol    = "HTTP"
  listener_port        = 80
  listener_description = "createdByTerraform"
  default_actions {
    type = "ForwardGroup"
    forward_group_config {
      server_group_tuples {
        server_group_id = alicloud_alb_server_group.default.id
      }
    }
  }
  # certificates {
  #   certificate_id = join("", [alicloud_ssl_certificates_service_certificate.default.id, "-cn-hangzhou"])
  # }
  acl_config {
    acl_type = "White"
    acl_relations {
      acl_id = alicloud_alb_acl.example.id
    }
  }
}

resource "alicloud_alb_acl" "example" {
  acl_name = "aliyun_l2"
  acl_entries {
    description = "example_value"
    entry       = "0.0.0.0/0"
  }
}
