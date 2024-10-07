terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.0.1"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-backend-tfstate-rs"                    # Can be passed via `-backend-config=`"resource_group_name=<resource group name>"` in the `init` command.
    storage_account_name = "sabetfsrrj1iohywz"                        # Can be passed via `-backend-config=`"storage_account_name=<storage account name>"` in the `init` command.
    container_name       = "tfstate"                                  # Can be passed via `-backend-config=`"container_name=<container name>"` in the `init` command.
    key                  = "backend.terraform.tfstate"                # Can be passed via `-backend-config=`"key=<blob key name>"` in the `init` command.
    client_id            = "d0ba7baa-7089-4cfb-9ee3-752ba53c6661"     # Can also be set via `ARM_CLIENT_ID` environment variable.
    client_secret        = "sUG8Q~m5vq1ToJZ54KyNo478i7Wk7bkXLDegidxi" # Can also be set via `ARM_CLIENT_SECRET` environment variable.
    subscription_id      = "efc1e7b1-5729-4eea-b33e-12cc6b1c0183"     # Can also be set via `ARM_SUBSCRIPTION_ID` environment variable.
    tenant_id            = "02feabb9-444e-4f66-9c13-6a8f04b75c2f"     # Can also be set via `ARM_TENANT_ID` environment variable.
  }

}

provider "azurerm" {
  # Configuration options
  subscription_id = "efc1e7b1-5729-4eea-b33e-12cc6b1c0183"

  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

resource "random_string" "random_string" {
  length  = 10
  special = false
  upper   = false
}


resource "azurerm_resource_group" "rg_backend" {
  name     = var.rg_backend_name
  location = var.rg_backend_location
}

resource "azurerm_storage_account" "sa_backend" {
  name                     = "${lower(var.sa_backend_name)}${random_string.random_string.result}"
  resource_group_name      = azurerm_resource_group.rg_backend.name
  location                 = azurerm_resource_group.rg_backend.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_storage_container" "sc_backend" {
  name                  = var.sc_backend_name
  storage_account_name  = azurerm_storage_account.sa_backend.name
  container_access_type = "private"
}



data "azurerm_client_config" "current" {}


resource "azurerm_key_vault" "kv_backend" {
  name                        = "${lower(var.kv_backend_name)}${random_string.random_string.result}"
  location                    = azurerm_resource_group.rg_backend.location
  resource_group_name         = azurerm_resource_group.rg_backend.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get", "List", "Create",
    ]

    secret_permissions = [
      "Get", "Set", "List",
    ]

    storage_permissions = [
      "Get", "Set", "List",
    ]
  }
}


resource "azurerm_key_vault_secret" "sa_backend_accesskey" {
  name         = var.sa_backend_accesskey_name
  value        = azurerm_storage_account.sa_backend.primary_access_key
  key_vault_id = azurerm_key_vault.kv_backend.id
}