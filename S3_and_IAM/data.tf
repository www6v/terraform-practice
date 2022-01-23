data "aws_iam_policy_document" "s3_bucket_policy" {
  statement {
    sid    = "AllowGetObject"
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
    ]

    resources = [
      "arn:${data.aws_partition.current.partition}:s3:::${local.bucket_name}/*",
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:role/${var.product}-${var.environment}-${var.role}-role"]
    }
  }
}

data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

data "aws_iam_policy_document" "kms_policy" {
  statement {
    sid    = "AllowForS3"
    effect = "Allow"

    actions = [
          "kms:GenerateDataKey*",
          "kms:Decrypt"
      ]

    resources = [
      "*",
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:role/${var.product}-${var.environment}-${var.role}-role"]
    }
  }
}