terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.0.1"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-backend-rs"            # Can be passed via `-backend-config=`"resource_group_name=<resource group name>"` in the `init` command.
    storage_account_name = "sabetfs2o1h8u2qjrh"       # Can be passed via `-backend-config=`"storage_account_name=<storage account name>"` in the `init` command.
    container_name       = "tfstate"                  # Can be passed via `-backend-config=`"container_name=<container name>"` in the `init` command.
    key                  = "modul9.terraform.tfstate" # Can be passed via `-backend-config=`"key=<blob key name>"` in the `init` command.

  }

}

provider "azurerm" {
  # Configuration options
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}