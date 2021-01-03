# Enable GCP APIs
resource "google_project_service" "run" {
  service = "run.googleapis.com"
}

# google_cloud_run_service.default:
resource "google_cloud_run_service" "default" {
  autogenerate_revision_name = true
  location                   = "${var.gcp_region}"
  name                       = "${var.project_name}-${var.environment_name}"
  project                    = "${var.project_name}"

  template {
    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale"      = "1"
        "run.googleapis.com/cloudsql-instances" = "${var.django_db_host}"
        "run.googleapis.com/client-name"        = "terraform"
      }
    }

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
          value = var.django_secret_key
        }
        env {
          name  = "DJANGO_DB_HOST"
          value = "/cloudsql/${var.django_db_host}"
        }
        env {
          name  = "DJANGO_DB_USER"
          value = "postgres"
        }
        env {
          name  = "DJANGO_DB_PASSWORD"
          value = var.django_db_password
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
        env {
          name  = "DJANGO_AWS_ACCESS_KEY_ID"
          value = var.django_aws_access_key
        }
        env {
          name  = "DJANGO_AWS_SECRET_ACCESS_KEY"
          value = var.django_aws_secret_access_key
        }
        env {
          name  = "DJANGO_AWS_STORAGE_BUCKET_NAME"
          value = "stbotolphs-ude3qzzeda"
        }
        env {
          name  = "DJANGO_AWS_S3_ENDPOINT_URL"
          value = "https://stbotolphs-ude3qzzeda.s3.eu-central-1.amazonaws.com"
        }
        env {
          name  = "DJANGO_DANGEROUS_DISABLE_AWS_USE_SSL"
          value = "0"
        }
        env {
          name  = "DJANGO_AWS_S3_REGION_NAME"
          value = "eu-central-1"
        }
        env {
          name  = "DJANGO_AWS_S3_HOST"
          value = "s3.eu-central-1.amazonaws.com"
        }

        ports {
          container_port = 8000
        }

        resources {
          limits = {
            "cpu"    = "1000m"
            "memory" = "256Mi"
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
  value = google_cloud_run_service.default.status[0].url
}