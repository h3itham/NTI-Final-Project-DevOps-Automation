# CREATE S3 BUCKET 
resource "aws_s3_bucket" "TerraformBackendS3" {
  bucket = "nti-finalproject-backend"  

  # PREVENT ACCIDENTAL DELETION OF THIS S3 BUCKET
  lifecycle {
    prevent_destroy = false
  }
} 

# ENABLE VERSIONING SO YOU CAN SEE THE FULL REVISION HISTORY OF YOUR STATE FILES
resource "aws_s3_bucket_versioning" "versioning-enabled" {
  bucket = aws_s3_bucket.TerraformBackendS3.id
  versioning_configuration {
    status = "Enabled"
  }
}

# ENABLE SERVER-SIDE ENCRYPTION BY DEFAULT
resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.TerraformBackendS3.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# EXPLICITLY BLOCK ALL PUBLIC ACCESS TO THE S3 BUCKET
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.TerraformBackendS3.id
  block_public_acls  = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

# BUILDING DYNAMODB TABLE 
resource "aws_dynamodb_table" "TerraformBackendLock" {
  name           = "TerraformBackendLock"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

## BACKEND CONFIGRUATION 
terraform {
	backend "s3" {

		bucket = "nti-finalproject-backend"
		key = "global/s3/terraform.tfstate"
        region = "us-east-1"
		dynamodb_table = "TerraformBackendLock"
		encrypt	= true
	}
}