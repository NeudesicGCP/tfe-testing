# This tests a manual workflow initiated from Terraform CLI
#
# Be sure to set your user token in ~/.terraformrc (OSX/Linux) or
#%APPDATA%/terraform.rc (Windows)
#
# See https://www.terraform.io/docs/commands/cli-config.html#credentials

# Use TFE as a backend; if all goes well this will **create** the workspace
# during init
terraform {
  backend "remote" {
    hostname     = "tfe.neudesicgcp.com"
    organization = "Neudesic"

    workspaces = {
      name = "manual"
    }
  }
}

# This is to ensure there is some configuration required
variable "message" {}

# Apply stage will only happen if there are resources to create
resource "random_string" "rnd" {
  length  = "4"
  special = false
}

output "greeting" {
  value = "${format("Hello, %s. This is your random string '%s'", var.message, random_string.rnd.result)}"
}
