# google_sql_database_instance.master:
resource "google_sql_database_instance" "master" {
  database_version    = "POSTGRES_13"
  deletion_protection = true

  name    = "stbotolphs-${var.environment_name}"
  project = "${var.project_name}"
  region  = "${var.gcp_region}"


  settings {
    activation_policy = "ALWAYS"
    availability_type = "ZONAL"
    disk_autoresize   = false
    disk_size         = 10
    disk_type         = "PD_SSD"
    pricing_plan      = "PER_USE"
    tier              = "db-f1-micro"
    user_labels = {
      "environment" = "production"
    }

    backup_configuration {
      binary_log_enabled             = false
      enabled                        = true
      location                       = "eu"
      point_in_time_recovery_enabled = true
      start_time                     = "16:00"
    }

    ip_configuration {
      ipv4_enabled = true
      require_ssl  = false

      authorized_networks {
        name  = "home1"
        value = "82.34.235.232/32"
      }
    }

    location_preference {
      zone = "europe-west1-d"
    }

    maintenance_window {
      // day 7 is Sunday
      day  = 7
      hour = 0
    }
  }

  timeouts {}
}

output "cloud_sql_ip_address" {
  value = google_sql_database_instance.master.public_ip_address
}

output "cloud_sql_connection_name" {
  value = google_sql_database_instance.master.connection_name
}
