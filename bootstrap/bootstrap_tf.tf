# Describes the resources used to store the terraform state
# read more @ https://www.terraform.io/docs/backends/types/s3.html

# This table is used to lock workspace state during runs
resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name         = "terraform-state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

}

# This bucket is used to store state of terraform workspaces
resource "aws_s3_bucket" "state_bucket" {
  bucket        = "${var.namespace}-terraform-backend-${var.account_name}"
  acl           = "private"
  force_destroy = true

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }

}

resource "aws_s3_bucket_public_access_block" "pipeline_bucket_access" {
  bucket = aws_s3_bucket.state_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

