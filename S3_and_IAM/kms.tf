resource "aws_kms_key" "key" {
  description              = "mykey"
  key_usage                = "ENCRYPT_DECRYPT"
  policy                   = data.aws_iam_policy_document.kms_policy.json
  deletion_window_in_days  = 30
  is_enabled               = true
  enable_key_rotation      = false
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  multi_region             = false
  tags = merge(
    {
      Name = var.kmskeys_name
    },
    local.default_tag_map
  )
}
