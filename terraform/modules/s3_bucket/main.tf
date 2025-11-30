###############################################
# S3 Bucket
###############################################
resource "aws_s3_bucket" "my-portfolio-bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = "dev"
  }
}

###############################################
# Versioning (optional)
###############################################
resource "aws_s3_bucket_versioning" "my-portfolio-version" {
  count  = var.enable_versioning ? 1 : 0
  bucket = aws_s3_bucket.my-portfolio-version.id

  versioning_configuration {
    status = "Enabled"
  }
}

###############################################
# Public Access Block
###############################################
resource "aws_s3_bucket_public_access_block" "portfolio-public-access" {
  bucket = aws_s3_bucket.portfolio-public-access.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

###############################################
# Encryption
###############################################
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

###############################################
# Website Hosting (Optional)
###############################################
resource "aws_s3_bucket_website_configuration" "this" {
  count  = var.enable_website ? 1 : 0
  bucket = aws_s3_bucket.this.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}
