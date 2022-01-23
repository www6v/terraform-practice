resource "aws_s3_bucket" "mybucket" {
  bucket = "mybucket"
  acl    = "private"

  versioning {
    enabled = false
  }
  policy            = data.aws_iam_policy_document.s3_bucket_policy.json
  force_destroy     = false
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = aws_kms_key.key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}
