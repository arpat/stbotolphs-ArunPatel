variable "environment_name" {
  type    = string
  default = "production"
}

variable "project_name" {
  type    = string
  default = "stbotolphs-297814"
}

variable "gcp_region" {
  type    = string
  default = "europe-west1"
}

variable "django_db_password" {
  type = string
}
variable "django_aws_access_key" {
  type = string
}
variable "django_aws_secret_access_key" {
  type = string
}
variable "django_secret_key" {
  type = string
}
