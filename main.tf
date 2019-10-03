data "google_billing_account" "master-billing" {
  display_name = var.billing_account_display_name
}

data "google_folder" "gps-monitoring" {
  folder = var.folder_id
}

resource "google_project" "monitoring-project" {
  name = "monitoring-resources"
  project_id = var.project_id
  folder_id = data.google_folder.gps-monitoring.id
  billing_account = data.google_billing_account.master-billing.id
}

resource "google_service_account" "cloudknox_sa" {
  display_name = "knox-sentry-vm-service-account"
  account_id = var.account_id
  project = var.project_id
}

resource "google_service_account_iam_member" "cloudknox_sa" {
  member = "serviceAccount:${google_service_account.cloudknox_sa.email}"
  role = "roles/iam.securityReviewer"
  service_account_id = google_service_account.cloudknox_sa.name
}

resource "google_service_account_iam_member" "cloudknox_sa_viewer" {
  member = "serviceAccount:${google_service_account.cloudknox_sa.email}"
  role = "roles/viewer"
  service_account_id = google_service_account.cloudknox_sa.name
}

resource "google_organization_iam_member" "cloudknox_secviwer" {
  member = "serviceAccount:${google_service_account.cloudknox_sa.email}"
  org_id = var.org_id
  role = "roles/iam.securityReviewer"
}

resource "google_organization_iam_member" "cloudknox_viewer" {
  member = "serviceAccount:${google_service_account.cloudknox_sa.email}"
  org_id = var.org_id
  role = "roles/viewer"
}

resource "google_compute_image" "cloudknox" {
  name = "knox-sentry-image"
  source_disk = "cloudknox-sentry/sentry.tar.gz"
  project = var.project_id
  depends_on = [google_project.monitoring-project]
}

resource "google_compute_network" "vpc" {
  name = "vpc-network-1"
  project = var.project_id
  auto_create_subnetworks = false
  routing_mode = "REGIONAL"
  delete_default_routes_on_create = true
  depends_on = [google_project.monitoring-project]
}

resource "google_compute_firewall" "cloudknox" {
  name = "knox-sentry-firewall-rule"
  network = google_compute_network.vpc.self_link
  allow {
    protocol = "tcp"
    ports = [9000]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["knox-sentry"]
}

resource "google_compute_instance" "cloudknox_instance" {
  name = "knox-sentry-vm"
  machine_type = "n1-standard-4"
  boot_disk {source = "cloudknox-sentry/sentry.tar.gz"}
  service_account {
    scopes = ["knox-sentry-vm-service-account"]
  }
  tags = ["knox-sentry"]
  network_interface {
    network = google_compute_network.vpc.self_link
  }
  depends_on = [google_service_account.cloudknox_sa, google_compute_firewall.cloudknox]
}





