resource "alicloud_slb_load_balancer" "default" {
  load_balancer_name = "tsj_demo_nlb"
  address_type       = "internet"
  load_balancer_spec = "slb.s2.small"
  vswitch_id         = alicloud_vswitch.enhanced.id
  tags = {
    info = "create for internet"
  }
}

resource "alicloud_slb_server_group" "default" {
  load_balancer_id = alicloud_slb_load_balancer.default.id
  name             = "tsj"
  servers {
    server_ids = [alicloud_instance.instance.id]
    type       = "ecs"
    port       = 80
    weight     = 100
  }
}

resource "alicloud_slb_listener" "default" {
  load_balancer_id          = alicloud_slb_load_balancer.default.id
  server_group_id           = alicloud_slb_server_group.default.id
  backend_port              = 80
  frontend_port             = 80
  protocol                  = "tcp"
  bandwidth                 = 10
  health_check              = "on"
  health_check_connect_port = 80
  healthy_threshold         = 8
  unhealthy_threshold       = 8
  health_check_timeout      = 8
  health_check_interval     = 5
  health_check_http_code    = "http_2xx,http_3xx"
  x_forwarded_for {
    retrive_slb_ip = true
    retrive_slb_id = true
  }
  acl_status      = "on"
  acl_type        = "white"
  acl_id          = alicloud_slb_acl.default.id
  request_timeout = 80
  idle_timeout    = 30
}

resource "alicloud_slb_acl" "default" {
  name       = "tsj"
  ip_version = "ipv4"
  entry_list {
    entry   = "114.82.96.68/32"
    comment = "only allow myself"
  }
}

