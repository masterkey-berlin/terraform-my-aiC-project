terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0" # Verwende dieselbe oder eine kompatible Version wie im Root-Modul
    }
  }
  # Optional: required_version für Terraform selbst im Modul
  # required_version = ">= 1.0"
}