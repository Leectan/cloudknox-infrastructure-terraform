variable "billing_account_display_name" {
  default = "guidepoint-gcp-master-billing"
}

variable "folder_id" {
  type = number
  description = "the id of the folder"
}

variable "project_id" {
  type = string
  description = "the prject id for cloudknox environment"
}

variable "region" {
  default = "us-east1"
  description = "default region for cloudknox provision"
}

variable "org_id" {
  type = number
  description = "org id"
}

variable "zone" {
  default = "us-east1-b"
  description = "default zone for cloudknox provision"
}

variable "account_id" {
  type = string
  default = "cloudknox-service"
  description = "The account id that is used to generate the service account email address"
}

