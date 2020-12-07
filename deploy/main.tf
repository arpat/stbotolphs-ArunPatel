// Configure the Google Cloud provider
provider "google" {
  project = "stbotolphs-297814"
  region  = "europe-west1"
}

// Enable GCP APIs
resource "google_project_service" "run" {
  service = "run.googleapis.com"
}
