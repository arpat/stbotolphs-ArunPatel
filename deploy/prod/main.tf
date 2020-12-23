// Configure the Google Cloud provider
provider "google" {
  project = "stbotolphs-297814"
  region  = "europe-west1"
}

// Configure the AWS provider
provider "aws" {
  region = "eu-central-1"
}

// Environment variables
variable "environment_name" {
  type    = string
  default = "prod"
}

variable "project_name" {
  type    = string
  default = "stbotolphs-297814"
}

variable "gcp_region" {
  type    = string
  default = "europe-west1"
}

// App env vars
variable "django_db_password" {
  type = string
  # pass as TF_VAR
  default = ""
}

variable "django_aws_access_key" {
  type    = string
  default = "AKIA3XP3GPVO4SHIOIWS"
}

variable "django_aws_secret_access_key" {
  type = string
  # pass as TF_VAR
}

variable "django_secret_key" {
  type    = string
  default = "WIcoveDc3IMko"
}


# module "database" {
#   source           = "../modules/cloud-sql"
#   environment_name = var.environment_name
#   project_name     = var.project_name
#   gcp_region       = var.gcp_region
# }


module "cloudrun" {
  source                       = "../modules/cloudrun"
  environment_name             = var.environment_name
  project_name                 = var.project_name
  gcp_region                   = var.gcp_region
  django_db_password           = var.django_db_password
  django_aws_access_key        = var.django_aws_access_key
  django_aws_secret_access_key = var.django_aws_secret_access_key # pass as TF_VAR
  django_secret_key            = var.django_secret_key
}
