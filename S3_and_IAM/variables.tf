variable "product" {
  type        = string
  description = "product"
  default     = "mobileapp"
}

variable "environment" {
  type        = string
  description = "env"
  default     = "staging"
}

variable "role" {
  type        = string
  description = "The engineer role"
  default     = "DevOps"
}


variable "kmskeys_name" {
  description = "kms key name"
  type = string
  default = "mykey"
}
