
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
