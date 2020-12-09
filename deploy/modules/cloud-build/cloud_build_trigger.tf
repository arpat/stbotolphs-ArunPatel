# google_cloudbuild_trigger.default:
resource "google_cloudbuild_trigger" "default" {
  description = "Build and deploy to Cloud Run service stbotolphs-production on push to \"^deploy/initial$\""
  # ignored_files  = []
  # included_files = []
  # name           = "rmgpgmb-stbotolphs-production-europe-west1-github-arpat-stbotfc"
  # project        = "stbotolphs-297814"
  substitutions = {
    "_DEPLOY_REGION" = "europe-west1"
    "_GCR_HOSTNAME"  = "eu.gcr.io"
    "_LABELS"        = "gcb-trigger-id=6ff071be-89c8-4f08-b465-1f7cec8891ca"
    "_PLATFORM"      = "managed"
    "_SERVICE_NAME"  = "stbotolphs-production"
    "_TRIGGER_ID"    = "6ff071be-89c8-4f08-b465-1f7cec8891ca"
  }
  tags = [
    "gcp-cloud-build-deploy-cloud-run",
    "gcp-cloud-build-deploy-cloud-run-managed",
    "stbotolphs-production",
  ]

  build {
    images = [
      "$_GCR_HOSTNAME/$PROJECT_ID/$REPO_NAME/$_SERVICE_NAME:$COMMIT_SHA",
    ]
    substitutions = {
      "_DEPLOY_REGION" = "europe-west1"
      "_GCR_HOSTNAME"  = "eu.gcr.io"
      "_LABELS"        = "gcb-trigger-id=6ff071be-89c8-4f08-b465-1f7cec8891ca"
      "_PLATFORM"      = "managed"
      "_SERVICE_NAME"  = "stbotolphs-production"
      "_TRIGGER_ID"    = "6ff071be-89c8-4f08-b465-1f7cec8891ca"
    }
    tags = [
      "gcp-cloud-build-deploy-cloud-run",
      "gcp-cloud-build-deploy-cloud-run-managed",
      "stbotolphs-production",
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

    # TODO - rework this to solve build step #3 - "Deploy": the ID is not unique
    # step {
    #   args = [
    #     "run",
    #     "services",
    #     "update",
    #     "$_SERVICE_NAME",
    #     "--platform=managed",
    #     "--image=$_GCR_HOSTNAME/$PROJECT_ID/$REPO_NAME/$_SERVICE_NAME:$COMMIT_SHA",
    #     "--region=$_DEPLOY_REGION",
    #     "--command=./manage.py",
    #     "--args=migrate",
    #     "--max-instances=1",
    #     "--timeout=300",
    #   ]
    #   entrypoint = "gcloud"
    #   env        = []
    #   id         = "Migrate"
    #   name       = "gcr.io/google.com/cloudsdktool/cloud-sdk"
    #   secret_env = []
    #   wait_for   = []
    # }

    step {
      args = [
        "run",
        "services",
        "update",
        "$_SERVICE_NAME",
        "--platform=managed",
        "--image=$_GCR_HOSTNAME/$PROJECT_ID/$REPO_NAME/$_SERVICE_NAME:$COMMIT_SHA",
        "--labels=managed-by=gcp-cloud-build-deploy-cloud-run,commit-sha=$COMMIT_SHA,gcb-build-id=$BUILD_ID,gcb-trigger-id=$_TRIGGER_ID,$_LABELS",
        "--region=$_DEPLOY_REGION",
        "--quiet",
      ]
      entrypoint = "gcloud"
      env        = []
      id         = "Deploy2"
      name       = "gcr.io/google.com/cloudsdktool/cloud-sdk"
      secret_env = []
      wait_for   = []
    }
  }

  timeouts {}

  trigger_template {
    branch_name  = "^deploy/initial$"
    invert_regex = false
    project_id   = "stbotolphs-297814"
    repo_name    = "github_arpat_stbotolphs-arunpatel"
  }
}
