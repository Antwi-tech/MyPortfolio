variable "bucket_name" {
  description = "The S3 bucket name"
  type        = string
}

variable "enable_versioning" {
  description = "Enable bucket versioning"
  type        = bool
  default     = false
}

variable "enable_website" {
  description = "Enable static website hosting"
  type        = bool
  default     = false
}
