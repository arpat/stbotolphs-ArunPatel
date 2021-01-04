# google_cloudbuild_trigger.default:
resource "google_cloudbuild_trigger" "default" {
  description = "Build and deploy to Cloud Run service ${var.project_name}-${var.environment_name} on push to \"^deploy/initial$\""
  substitutions = {
    "_DEPLOY_REGION" = "${var.gcp_region}"
    "_GCR_HOSTNAME"  = "eu.gcr.io"
    "_LABELS"        = "gcb-trigger-id=6ff071be-89c8-4f08-b465-1f7cec8891ca"
    "_PLATFORM"      = "managed"
    "_SERVICE_NAME"  = "${var.project_name}-${var.environment_name}"
    "_TRIGGER_ID"    = "6ff071be-89c8-4f08-b465-1f7cec8891ca"
  }
  tags = [
    "gcp-cloud-build-deploy-cloud-run",
    "gcp-cloud-build-deploy-cloud-run-managed",
    "${var.project_name}-${var.environment_name}",
  ]

  build {
    images = [
      "$_GCR_HOSTNAME/$PROJECT_ID/$REPO_NAME/$_SERVICE_NAME:$COMMIT_SHA",
    ]
    substitutions = {
      "_DEPLOY_REGION" = "${var.gcp_region}"
      "_GCR_HOSTNAME"  = "eu.gcr.io"
      "_LABELS"        = "gcb-trigger-id=6ff071be-89c8-4f08-b465-1f7cec8891ca"
      "_PLATFORM"      = "managed"
      "_SERVICE_NAME"  = "${var.project_name}-${var.environment_name}"
      "_TRIGGER_ID"    = "6ff071be-89c8-4f08-b465-1f7cec8891ca"
    }
    tags = [
      "gcp-cloud-build-deploy-cloud-run",
      "gcp-cloud-build-deploy-cloud-run-managed",
      "${var.project_name}-${var.environment_name}",
    ]

    options {
      disk_size_gb           = 0
      dynamic_substitutions  = false
      env                    = []
      secret_env             = []
      source_provenance_hash = []
      substitution_option    = "ALLOW_LOOSE"
    }

    step {
      args = [
        "build",
        "--no-cache",
        "-t",
        "$_GCR_HOSTNAME/$PROJECT_ID/$REPO_NAME/$_SERVICE_NAME:$COMMIT_SHA",
        ".",
        "-f",
        "Dockerfile",
      ]
      env        = []
      id         = "Build"
      name       = "gcr.io/cloud-builders/docker"
      secret_env = []
      wait_for   = []
    }

    step {
      args = [
        "push",
        "$_GCR_HOSTNAME/$PROJECT_ID/$REPO_NAME/$_SERVICE_NAME:$COMMIT_SHA",
      ]
      env        = []
      id         = "Push"
      name       = "gcr.io/cloud-builders/docker"
      secret_env = []
      wait_for   = []
    }

    # force an exit 0 to alloe the build step to pass to the next stage
    step {
      args = [
        "-xc",
        "gcloud run services update $_SERVICE_NAME --platform=managed --image=$_GCR_HOSTNAME/$PROJECT_ID/$REPO_NAME/$_SERVICE_NAME:$COMMIT_SHA --region=$_DEPLOY_REGION --command=sh --args=-c,./migrate.sh --max-instances=1 --timeout=300 || true",
        "true",
      ]
      entrypoint = "bash"
      env        = []
      id         = "Makemigrations"
      name       = "gcr.io/google.com/cloudsdktool/cloud-sdk"
      secret_env = []
      wait_for   = []
    }
    
    step {
      args = [
        "-xc",
        "gcloud run services update $_SERVICE_NAME --platform=managed --image=$_GCR_HOSTNAME/$PROJECT_ID/$REPO_NAME/$_SERVICE_NAME:$COMMIT_SHA --region=$_DEPLOY_REGION --max-instances=1 --timeout=300 --command=''",
      ]
      entrypoint = "bash"
      env        = []
      id         = "PreDeploy"
      name       = "gcr.io/google.com/cloudsdktool/cloud-sdk"
      secret_env = []
      wait_for   = []
    }
  
  ##############################################################################
  #   step {
  #     args = [
  #       "run",
  #       "services",
  #       "update",
  #       "$_SERVICE_NAME",
  #       "--platform=managed",
  #       "--image=$_GCR_HOSTNAME/$PROJECT_ID/$REPO_NAME/$_SERVICE_NAME:$COMMIT_SHA",
  #       "--labels=managed-by=gcp-cloud-build-deploy-cloud-run,commit-sha=$COMMIT_SHA,gcb-build-id=$BUILD_ID,gcb-trigger-id=$_TRIGGER_ID,$_LABELS",
  #       "--command=''",
  #       "--region=$_DEPLOY_REGION",
  #     ]
  #     entrypoint = "gcloud"
  #     env        = []
  #     id         = "Deploy"
  #     name       = "gcr.io/google.com/cloudsdktool/cloud-sdk"
  #     secret_env = []
  #     wait_for   = []
  #   }
  # }

  timeouts {}

  trigger_template {
    branch_name  = "^deploy/post-submission$"
    invert_regex = false
    project_id   = "${var.project_name}"
    repo_name    = "github_arpat_stbotolphs-arunpatel"
  }
}
