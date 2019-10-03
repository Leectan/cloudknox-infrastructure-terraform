terraform {
  required_version = ">= 0.12"
}

provider "google" {
  version = "2.13.0"
  region = var.region
  zone = var.zone
}

provider "google-beta" {
  version = "2.13.0"
}

