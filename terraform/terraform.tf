# terraform destroy -target=azurerm_linux_virtual_machine.minevm
# Configure the Microsoft Azure Provider
provider azurerm {
      features {}
    #   version = "~>2.0"
    #   subscription_id = "${var.subscription_id}"
    #   client_id       = "${module.vaultprovider.client_id}"
    #   client_secret   = "${module.vaultprovider.client_secret}"
    #   tenant_id       = "${var.tenant_id}"
}

# Create a resource group if it doesn't exist
resource "azurerm_resource_group" "minecraft" {
  name = "minecraft"
  location = var.region
}

# Create a managed disk
resource "azurerm_managed_disk" "minedisk" {
  name                 = "minecraft-disk"
  location             = var.region
  resource_group_name  = azurerm_resource_group.minecraft.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "30" # 30GB minimal for the image

  tags = {
    environment = "production"
  }
}

# Create virtual network
resource "azurerm_virtual_network" "minenetwork" {
    name                = "minecraft-net"
    address_space       = ["10.0.0.0/16"]
    location            = var.region
    resource_group_name = azurerm_resource_group.minecraft.name

    tags = {
        environment = "production"
    }
}

# Create subnet
resource "azurerm_subnet" "minesubnet" {
    name                 = "mine-sub"
    resource_group_name  = azurerm_resource_group.minecraft.name
    virtual_network_name = azurerm_virtual_network.minenetwork.name
    address_prefixes       = ["10.0.1.0/24"]
}

# Create public IPs
resource "azurerm_public_ip" "mineip" {
    name                         = "mineip"
    location                     = var.region
    resource_group_name          = azurerm_resource_group.minecraft.name
    allocation_method            = "Static"

    tags = {
        environment = "production"
    }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "minesecgroup" {
    name                = "minesecgroup"
    location            = var.region
    resource_group_name = azurerm_resource_group.minecraft.name

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
    security_rule {
        name                       = "Mine"
        priority                   = 1002
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "25565"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }


    tags = {
        environment = "production"
    }
}

# Create network interface
resource "azurerm_network_interface" "minenic" {
    name                      = "minecraft"
    location                  = var.region
    resource_group_name       = azurerm_resource_group.minecraft.name

    ip_configuration {
        name                          = "myNicConfiguration"
        subnet_id                     = azurerm_subnet.minesubnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.mineip.id
    }

    tags = {
        environment = "production"
    }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
    network_interface_id      = azurerm_network_interface.minenic.id
    network_security_group_id = azurerm_network_security_group.minesecgroup.id
}


# Create (and display on output) an SSH key
# resource "tls_private_key" "minesshkey" {
#   algorithm = "RSA"
#   rsa_bits = 4096
# }
# output "tls_private_key" { value = tls_private_key.minesshkey.private_key_pem }

# Create virtual machine
resource "azurerm_linux_virtual_machine" "minevm" {
    name                  = "minecraft"
    location              = var.region
    resource_group_name   = azurerm_resource_group.minecraft.name
    network_interface_ids = [azurerm_network_interface.minenic.id]
    size                  = "Standard_B1s"
    # size                  = "Standard_DS1_v2"

    # Set VM to Spot
    # priority = "Spot"
    # eviction_policy = "Deallocate"


    os_disk {
        # name = "mineosdisk" # (optional) needs to be unique on RG if name is set, when another machine is created gives error
        caching           = "ReadWrite"
        storage_account_type = "Premium_LRS"
        disk_size_gb = 30
        # Set disk to ephemeral (read only?)
        # diff_disk_settings {
        # option = "Local"
        # }
    }

    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }

    computer_name  = "minecraft"
    admin_username = "azureuser"
    disable_password_authentication = true

    admin_ssh_key {
        username       = "azureuser"
        public_key     = file(var.pub_ssh_file)
        # public_key     = tls_private_key.minesshkey.public_key_openssh
    }


    tags = {
        environment = "production"
    }
}

resource "local_file" "hosts" {
    content  = azurerm_linux_virtual_machine.minevm.public_ip_address
    filename = "../ansible/hosts"
}

resource "azurerm_virtual_machine_data_disk_attachment" "attachminedisk" {
  managed_disk_id    = azurerm_managed_disk.minedisk.id
  virtual_machine_id = azurerm_linux_virtual_machine.minevm.id
  lun                = "10"
  caching            = "ReadWrite"
}

resource "azurerm_storage_account" "example" {
  name                     = "startstopfunc"
  resource_group_name      = azurerm_resource_group.minecraft.name
  location                 = azurerm_resource_group.minecraft.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "example" {
  name                = "azure-functions-test-service-plan"
  location            = azurerm_resource_group.minecraft.location
  resource_group_name = azurerm_resource_group.minecraft.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_function_app" "example" {
  name                       = "mine-function"
  location                   = azurerm_resource_group.minecraft.location
  resource_group_name        = azurerm_resource_group.minecraft.name
  app_service_plan_id        = azurerm_app_service_plan.example.id
  storage_account_name       = azurerm_storage_account.example.name
  storage_account_access_key = azurerm_storage_account.example.primary_access_key
}