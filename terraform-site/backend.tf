#Assumes S3 bucket is already set up at AWS.
terraform { 
	backend "s3" {  
		bucket = "kreuzwerker-state" 
		key = "kreuzwerker.tfstate"
		region = "us-west-2"
		profile = "terraform-user"
	}
}


