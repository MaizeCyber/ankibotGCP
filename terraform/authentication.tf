# 1. Create the Service Account in the Target Project
resource "google_service_account" "github_deployer" {
  project      = "ankiconnect-482403"
  account_id   = "github-deployer"
  display_name = "GitHub Actions Deployer"
}

resource "google_project_iam_member" "dev_ops" {
  project = "ankiconnect-482403"
  role    = "roles/editor"
  member  = "serviceAccount:${google_service_account.github_deployer.email}"
}

# 2. Grant the Workload Identity User role to the GitHub identity
resource "google_service_account_iam_member" "wif_binding" {
  service_account_id = google_service_account.github_deployer.name
  role               = "roles/iam.workloadIdentityUser"

  # This string references the Hub Project's Pool
  member = "principalSet://iam.googleapis.com/projects/334515927364/locations/global/workloadIdentityPools/gh-action-minecraft-pool/attribute.repository/maizecyber/ankibotGCP"
}