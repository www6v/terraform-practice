locals {
  bucket_name = "tests3fordhutsj"
  aws_iam_service           = data.aws_partition.current.partition == "aws" ? "amazonaws.com" : "amazonaws.com.cn"
  default_tag_map = merge(
    {
      Product             = var.product
      Environment         = var.environment
    }  
    )
}
