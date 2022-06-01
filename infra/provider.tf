provider "google" {
  project = "oat-dev-eu"
}
provider "google-beta" {
  project = "oat-dev-eu"
}
provider "archive" {
  # Configuration options
}

provider "random" {
  # Configuration options
}
terraform {
  required_providers {
    google      = {}
    google-beta = {}
    archive     = {}
  }
}