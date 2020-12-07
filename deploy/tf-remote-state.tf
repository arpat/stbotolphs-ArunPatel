terraform {
  backend "gcs" {
    bucket = "tf-state-stbotolphs-297814"
    prefix = "terraform/state"
  }
}
