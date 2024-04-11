
resource "azurerm_resource_group" "appgrp" {
  name     = local.resource_group_name
  location = local.location
}

resource "azurerm_storage_account" "appstoresolarecl24" {
    name = "appstoresolarecl24"
    resource_group_name = local.resource_group_name
    location = "centralus"
    account_tier = "Standard"
    account_replication_type = "LRS"
    account_kind = "StorageV2"
    depends_on = [ azurerm_resource_group.appgrp ]
}

resource "azurerm_storage_container" "data" {
    count = 3
    name = "${count.index}data"
    storage_account_name =  "appstoresolarecl24"
    container_access_type = "blob"
    depends_on = [  azurerm_storage_account.appstoresolarecl24 ]
}

# resource "azurerm_storage_blob" "maintf" {
#   name                   = "main.tf"
#   storage_account_name   = "appstoresolarecl24"
#   storage_container_name = "data"
#   type                   = "Block"
#   source                 = "main.tf"
#   depends_on = [ azurerm_storage_container.data ]
# }

# resource "azurerm_virtual_network" "appnetwork" {
#   name                = local.virtual_network.name
#   address_space       = [local.virtual_network.address_space]
#   location            = local.location
#   resource_group_name = local.resource_group_name
#   dns_servers = ["10.0.0.4","10.0.0.5"]

#   subnet {
#     name = local.subneta.name
#     address_prefix = local.subneta.address_prefix
#   }

#   subnet {
#     name = local.subnetb.name
#     address_prefix = local.subneta.address_prefix
#   }
  
#   depends_on = [azurerm_resource_group.appgrp]
# }

resource "azurerm_subnet" "subneta" {
  name                 = local.subneta.name
  resource_group_name  = local.resource_group_name
  virtual_network_name = local.virtual_network.name
  address_prefixes     = [local.subneta.address_prefix]
}

resource "azurerm_subnet" "subnetb" {
  name                 = local.subnetb.name
  resource_group_name  = local.resource_group_name
  virtual_network_name = local.virtual_network.name
  address_prefixes     = [local.subnetb.address_prefix]
}


resource "azurerm_network_interface" "appinterface" {
  name                = "appinterface"
  location            = local.location
  resource_group_name = local.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subneta.id
    private_ip_address_allocation = "Dynamic"
  }
  depends_on = [ azurerm_subnet.subneta ]
}

output "subnet_a_id" {
    value = azurerm_subnet.subneta.id
}