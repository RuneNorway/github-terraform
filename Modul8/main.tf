# az storage blob list --container-name tfstate --account-name sabetfs2o1h8u2qjrh --output table

locals {
  workspaces_suffix = terraform.workspace == "default" ? "" : "${terraform.workspace}"

  rg_name           = terraform.workspace == "default" ? "${var.rg_name}" : "${var.rg_name}- ${local.workspaces_suffix}"
  sa_name           = terraform.workspace == "default" ? "${var.sa_name}" : "${var.sa_name}- ${local.workspaces_suffix}"
  web_suffix        = terraform.workspace == "default" ? "<h1> Default workspace</h1>" : "<h1> ${terraform.workspace}</h1>"
}

resource "random_string" "random_string" {
  length  = 8
  special = false
  upper   = false

}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = var.rg_location

}
output "rg_name" {
  value = azurerm_resource_group.rg.name
}

# Create Storage account 
resource "azurerm_storage_account" "sa-web" {
  name                     = "${lower(var.sa_name)}${random_string.random_string.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  static_website {
    index_document = var.index_document
  }
}

# Add a index.html page to the storage account 
resource "azurerm_storage_blob" "index_html" {
  name                   = var.index_document
  storage_account_name   = azurerm_storage_account.sa-web.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/html"
  source_content         = "${var.source_content}${local.web_suffix}"

}
output "primary_web_endpoint" {
  value = azurerm_storage_account.sa-web.primary_web_endpoint

}