// Configure the Google Cloud provider
provider "google" {
  project = "stbotolphs-297814"
  region  = "europe-west1"
}

// Enable GCP APIs
resource "google_project_service" "run" {
  service = "run.googleapis.com"
}

// Configure the AWS provider
provider "aws" {
  region = "eu-central-1"
}


// Environment variables
variable "environment_name" {
  type    = string
  default = "dev"
}

variable "project_name" {
  type    = string
  default = "stbotolphs-297814"
}

variable "gcp_region" {
  type    = string
  default = "europe-west1"
}


module "database" {
  source           = "../modules/cloud-sql"
  environment_name = var.environment_name
  project_name     = var.project_name
  gcp_region       = var.gcp_region
}