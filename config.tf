terraform {
  backend "s3" {
    bucket = "example-app-remote-state" #Assuming this exists and is appropriately configured
    key    = "example-app-RDS"
    region = var.region
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.57.0"
    }
  }
  required_version = "~>1.9.1"
}

provider "aws" {
  region = var.region #Default region 
  # Assume you have credientals sourced from outside terrform in ENVARS or aws config profiles
}
