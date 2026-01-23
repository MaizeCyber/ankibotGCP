resource "google_service_account" "anki_sa" {
  account_id   = "anki-server-sa"
  display_name = "Anki Server Service Account"
}

resource "google_project_iam_member" "anki_sa_secrets" {
  project = var.project_name
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.anki_sa.email}"
}

resource "google_project_iam_member" "anki_sa_run_admin" {
  project = var.project_name
  role    = "roles/run.admin"
  member  = "serviceAccount:${google_service_account.anki_sa.email}"
}

resource "google_project_iam_member" "anki_sa_vertex_admin" {
  project = var.project_name
  role    = "roles/aiplatform.user"
  member  = "serviceAccount:${google_service_account.anki_sa.email}"
}

resource "google_project_iam_member" "logging_writer" {
  project = var.project_name
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.anki_sa.email}"
}

resource "google_project_iam_member" "anki_sa_instance_admin" {
  project = var.project_name
  role    = "roles/compute.instanceAdmin.v1"
  member  = "serviceAccount:${google_service_account.anki_sa.email}"
}

data "google_project" "project" {}

resource "google_pubsub_topic_iam_member" "monitoring_publisher" {
  topic      = google_pubsub_topic.ankibot_idle_topic.name
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-monitoring-notification.iam.gserviceaccount.com"
  depends_on = [google_monitoring_notification_channel.pubsub_channel]
}

resource "google_project_iam_member" "tokencreator" {
  project = data.google_project.project.id
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-pubsub.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "functionbuildpermission" {
  project = data.google_project.project.id
  role    = "roles/cloudbuild.builds.builder"
  member  = "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com"
}

resource "google_project_iam_member" "functionlogpermission" {
  project = data.google_project.project.id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com"
}

resource "google_project_iam_member" "functionobjectpermission" {
  project = data.google_project.project.id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com"
}

resource "google_project_iam_member" "functionartifactpermission" {
  project = data.google_project.project.id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com"
}

resource "google_service_account" "stop_function_sa" {
  account_id   = "stop-function-sa"
  display_name = "Cloud function suspend service account"
}

resource "google_project_iam_member" "function_stop_instance" {
  project = var.project_name
  role    = "roles/compute.instanceAdmin.v1"
  member  = "serviceAccount:${google_service_account.stop_function_sa.email}"
}

resource "google_service_account" "eventarc" {
  account_id   = "eventarc-trigger-sa"
  display_name = "Eventarc Trigger Service Account"
}

resource "google_project_iam_member" "eventreceiver" {
  project = var.project_name
  role    = "roles/eventarc.eventReceiver"
  member  = "serviceAccount:${google_service_account.eventarc.email}"
}

resource "google_project_iam_member" "runinvoker" {
  project = var.project_name
  role    = "roles/run.invoker"
  member  = "serviceAccount:${google_service_account.eventarc.email}"
}