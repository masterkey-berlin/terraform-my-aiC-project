terraform {
  required_version = ">= 1.0" # oder spezifischer
  required_providers {
    # Beispiel Docker Provider
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
    # Füge hier andere Provider hinzu, falls benötigt (z.B. random)
  }
}

# Provider-Konfiguration (kann auch in provider.tf stehen)
provider "docker" {
  # Ggf. Host-Konfiguration, falls nötig
}