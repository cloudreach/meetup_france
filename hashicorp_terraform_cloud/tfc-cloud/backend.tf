terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "Cloudreach_France"

    workspaces {
      prefix = "meetup-"
    }
  }
}