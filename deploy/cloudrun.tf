# google_cloud_run_service.default:
resource "google_cloud_run_service" "default" {
  autogenerate_revision_name = true
  location                   = "europe-west1"
  name                       = "stbotolphs-production"
  project                    = "stbotolphs-297814"

  template {
    spec {
      container_concurrency = 80
      service_account_name  = "owner-project@stbotolphs-297814.iam.gserviceaccount.com"
      timeout_seconds       = 300

      containers {
        args    = []
        command = []
        image   = "eu.gcr.io/stbotolphs-297814/github_arpat_stbotolphs-arunpatel/stbotolphs-production:1ee626bab6af2e6eecc6ade5f0a3b5c2f1a74f1d"

        env {
          name  = "DJANGO_SECRET_KEY"
          value = "WIcoveDc3IMko"
        }
        env {
          name  = "DJANGO_DB_HOST"
          value = "/cloudsql/stbotolphs-297814:europe-west1:stbotolphs-production"
        }
        env {
          name  = "DJANGO_DB_USER"
          value = "postgres"
        }
        env {
          name  = "DJANGO_DB_PASSWORD"
          value = "LbpdHqvD6lne0Pol"
        }
        env {
          name  = "DJANGO_DB_ENGINE"
          value = "django.db.backends.postgresql"
        }
        env {
          name  = "DJANGO_DB_NAME"
          value = "cms"
        }
        env {
          name  = "DJANGO_DB_CONN_MAX_AGE"
          value = "60"
        }

        ports {
          container_port = 8000
        }

        resources {
          limits = {
            "cpu"    = "1000m"
            "memory" = "128Mi"
          }
          requests = {}
        }
      }
    }
  }

  timeouts {}

  traffic {
    latest_revision = true
    percent         = 100
  }

  // requires the Cloud Resource Manager API
  depends_on = [google_project_service.run]
}


// This is a public website, allow allUsers
resource "google_cloud_run_service_iam_member" "allUsers" {
  service  = google_cloud_run_service.default.name
  location = google_cloud_run_service.default.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}

// cloud run service endpoint URL
output "url" {
  value = "${google_cloud_run_service.default.status[0].url}"
}