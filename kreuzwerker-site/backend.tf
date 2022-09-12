terraform { 
	backend "s3" {  
		bucket = "kreuzwerker-state" 
		key = "kreuzwerker.tfstate"
		region = "us-west-2"
		profile = "default"
	}
}
