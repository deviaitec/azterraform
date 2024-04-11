provider "azurerm" {
  features {}
}

# Define Azure regions
variable "regions" {
  type    = list(string)
  default = ["East US", "West Europe", "Southeast Asia"]
}

# Create a resource group in each region
resource "azurerm_resource_group" "marketing_rg" {
  count     = length(var.regions)
  name      = "marketing-rg-${var.regions[count.index]}"
  location  = var.regions[count.index]
}

# Create a virtual network in each region
resource "azurerm_virtual_network" "marketing_vnet" {
  count               = length(var.regions)
  name                = "marketing-vnet-${var.regions[count.index]}"
  location            = azurerm_resource_group.marketing_rg[count.index].location
  resource_group_name = azurerm_resource_group.marketing_rg[count.index].name
  address_space       = ["10.${count.index}.0.0/16"]
}

# Create a web app in each region
resource "azurerm_app_service_plan" "marketing_app_service_plan" {
  count               = length(var.regions)
  name                = "marketing-appservice-plan-${var.regions[count.index]}"
  location            = azurerm_resource_group.marketing_rg[count.index].location
  resource_group_name = azurerm_resource_group.marketing_rg[count.index].name
  kind                = "Windows"
  reserved            = true

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "marketing_web_app" {
  count                     = length(var.regions)
  name                      = "marketing-webapp-${var.regions[count.index]}"
  location                  = azurerm_resource_group.marketing_rg[count.index].location
  resource_group_name       = azurerm_resource_group.marketing_rg[count.index].name
  app_service_plan_id       = azurerm_app_service_plan.marketing_app_service_plan[count.index].id
  site_config {
    always_on              = true
    dotnet_framework_version = "v4.0"
    scm_type               = "LocalGit"
  }
}

# Create a mobile app in each region
resource "azurerm_app_service" "marketing_mobile_app" {
  count                     = length(var.regions)
  name                      = "marketing-mobileapp-${var.regions[count.index]}"
  location                  = azurerm_resource_group.marketing_rg[count.index].location
  resource_group_name       = azurerm_resource_group.marketing_rg[count.index].name
  app_service_plan_id       = azurerm_app_service_plan.marketing_app_service_plan[count.index].id
  site_config {
    always_on              = true
    linux_fx_version       = "NODE|10.14"
  }
}

# Create a database in each region
resource "azurerm_sql_server" "marketing_sql_server" {
  count               = length(var.regions)
  name                = "marketing-sqlserver-${var.regions[count.index]}"
  location            = azurerm_resource_group.marketing_rg[count.index].location
  resource_group_name = azurerm_resource_group.marketing_rg[count.index].name
  version             = "12.0"
  administrator_login = "sqladmin"
  administrator_login_password = "P@ssw0rd1234!"
}

resource "azurerm_sql_database" "marketing_sql_db" {
  count               = length(var.regions)
  name                = "marketing-sqldb-${var.regions[count.index]}"
  location            = azurerm_resource_group.marketing_rg[count.index].location
  resource_group_name = azurerm_resource_group.marketing_rg[count.index].name
  server_name         = azurerm_sql_server.marketing_sql_server[count.index].name
  sku_name            = "Basic"
  collation           = "SQL_Latin1_General_CP1_CI_AS"
}


