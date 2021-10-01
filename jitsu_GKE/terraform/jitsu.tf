resource "google_service_account" "jitsu-service_account" {
  project      = var.project
  account_id   = "jitsu-server"
  display_name = "jitsu- server"
}


resource "google_compute_global_address" "jitsu_ip_address" {
  name         = "jitsu-static-ip"
  address_type = "EXTERNAL"
  project      = var.project
  description  = "jitsu server ip"
}

resource "google_dns_record_set" "jitsu-ingress-recordset" {
  managed_zone = google_dns_managed_zone.hosted-zone.name
  name         = "jitsu-api.${google_dns_managed_zone.hosted-zone.dns_name}"
  type         = "A"
  rrdatas      = [google_compute_global_address.jitsu_ip_address.address]
  ttl          = 300
}

resource "google_storage_bucket" "jitsu-maxmind-db" {
  name     = "${var.project}-mmmdb"
  location = "US"
}

data "google_iam_policy" "maxmind_bucket_admin" {
  binding {
    role    = "roles/storage.objectViewer"
    members = [
      "serviceAccount:${google_service_account.jitsu-service_account.email}",
    ]
  }
}

resource "google_storage_bucket_iam_policy" "maxmind-bucket-policy" {
  bucket      = google_storage_bucket.jitsu-maxmind-db.name
  policy_data = data.google_iam_policy.maxmind_bucket_admin.policy_data
}


resource "google_project_iam_binding" "ends_gsa_ksa_binding" {
  project = var.project
  role               = "roles/iam.workloadIdentityUser"

  members = [
    "serviceAccount:${var.project}.svc.id.goog[jitsu/jitsu-sa]",
  ]
}
