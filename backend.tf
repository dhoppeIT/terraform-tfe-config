terraform {
  backend "remote" {
    organization = "dhoppeIT"

    workspaces {
      name = "FIXME"
    }
  }
}
