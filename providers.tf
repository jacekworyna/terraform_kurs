terraform {
  required_version = "~> 1.10"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.70.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-crc2026-student-212-lab"
    storage_account_name = "jworynasatf"
    container_name       = "terraform"
    key                  = "terraform.tfstate"
  }
}


provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = false
      recover_soft_deleted_key_vaults = true
    }
  }
  resource_provider_registrations = "none"
}