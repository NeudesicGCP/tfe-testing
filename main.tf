# Investigations...

# Use the latest 2.x Google provider >= 2.5.1
provider "google" {
  version     = "~> 2.0, >= 2.5.1"
  credentials = "${var.credentials}"

  scopes = [
    "https://www.googleapis.com/auth/cloud-platform",
    "https://www.googleapis.com/auth/userinfo.email",
  ]
}

data "google_client_openid_userinfo" "whoami" {}

# Apply stage will only happen if there are resources to create
resource "random_string" "rnd" {
  length  = "4"
  special = false
}

output "whoami" {
  value = "${data.google_client_openid_userinfo.whoami.email}"
}
