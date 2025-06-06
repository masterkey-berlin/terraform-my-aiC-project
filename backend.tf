
terraform {
  required_version = ">= 1.0" # Deine Terraform Versionsanforderung
  required_providers {
    # ... deine bisherigen Provider-Deklarationen (z.B. Docker) ...
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
    # Füge hier den AzureRM Provider hinzu.
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0" # Beispielversion, prüfe die aktuelle
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-24-08-on-..." 
    storage_account_name = "terraformstate66"
    container_name       = "tfstate"        
    key                  = "my-iac-project/terraform.tfstate"
  }
}

# Ggf. deine provider "docker" {} und provider "azurerm" {} Blöcke hier oder in provider.tf
provider "azurerm" {
  features {} # Notwendiger, oft leerer Block für den AzureRM Provider
}