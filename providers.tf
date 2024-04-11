terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.98.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  subscription_id = "85e4d47f-c502-4973-8843-19751f230339"
  tenant_id = "450b3eda-64e6-4877-ab73-8deac670bc19"
  client_id = "820668b7-bee4-4537-b183-979064d370cc"
  client_secret = ""
  features{
  }
  skip_provider_registration = true
}
