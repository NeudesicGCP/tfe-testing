# Investigations...

variable "foobar" {}

variable "credentials" {}

# Use the latest 2.x Google provider >= 2.5.1
provider "google" {
  version = "~> 2.0, >= 2.5.1"
  alias   = "executor"

  credentials = "${var.credentials}"

  scopes = [
    "https://www.googleapis.com/auth/cloud-platform",
    "https://www.googleapis.com/auth/userinfo.email",
  ]
}

data "google_client_config" "default" {
  provider = "google.executor"
}

data "google_service_account_access_token" "atum" {
  provider               = "google.executor"
  target_service_account = "terraform@atum-the-creator.iam.gserviceaccount.com"
  lifetime               = "10s"

  scopes = [
    "https://www.googleapis.com/auth/cloud-platform",
    "https://www.googleapis.com/auth/userinfo.email",
  ]
}

provider "google" {
  version      = "~> 2.0, >= 2.5.1"
  access_token = "${data.google_service_account_access_token.atum.access_token}"
}

data "google_client_openid_userinfo" "whoami" {
  provider = "google.executor"
}

data "google_client_openid_userinfo" "whoareyou" {
  provider = "google"
}

# Apply stage will only happen if there are resources to create
resource "random_string" "rnd" {
  length  = "5"
  special = false
}

output "whoami" {
  value = "${format("I am %s, but I want to be %s", data.google_client_openid_userinfo.whoami.email, data.google_client_openid_userinfo.whoareyou.email)}"
}
