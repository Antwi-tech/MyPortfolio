provider "aws" {
  region = "us-east-1"
}

module "app_bucket" {
  source = "./modules/s3_bucket"

  bucket_name       = var.bucket_name
  enable_versioning = true
  enable_website    = true
}
