terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.56.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider azurerm {
      features {}
      subscription_id = "${var.subscription_id}"
      client_id       = "${var.client_id}"
      client_secret   = "${var.client_secret}"
      tenant_id       = "${var.tenant_id}"
}

# Create a resource group if it doesn't exist
resource "azurerm_resource_group" "rg" {
  name = var.rg_name
  location = var.region
}

# Create virtual network
resource "azurerm_virtual_network" "vnet" {
    name                = "${var.project_name}-net"
    address_space       = ["10.0.0.0/16"]
    location            = var.region
    resource_group_name = azurerm_resource_group.rg.name
}

# Create subnet
resource "azurerm_subnet" "subnet" {
    name                 = "${var.project_name}-sub"
    resource_group_name  = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes       = ["10.0.1.0/24"]
}

# Create public IPs
resource "azurerm_public_ip" "pip" {
    name                         = "${var.project_name}-pip"
    location                     = var.region
    resource_group_name          = azurerm_resource_group.rg.name
    allocation_method            = "Static"
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "secgroup" {
    name                = "secgroup"
    location            = var.region
    resource_group_name = azurerm_resource_group.rg.name

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
        name                       = "${var.project_name}"
        priority                   = 1002
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "25565"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
}

# Create network interface
resource "azurerm_network_interface" "nic" {
    name                      = "${var.project_name}-nic"
    location                  = var.region
    resource_group_name       = azurerm_resource_group.rg.name

    ip_configuration {
        name                          = "myNicConfiguration"
        subnet_id                     = azurerm_subnet.subnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.pip.id
    }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
    network_interface_id      = azurerm_network_interface.nic.id
    network_security_group_id = azurerm_network_security_group.secgroup.id
}

# Create (and display on output) an SSH key
# resource "tls_private_key" "sshkey" {
#   algorithm = "RSA"
#   rsa_bits = 4096
# }
# output "tls_private_key" { value = tls_private_key.sshkey.private_key_pem }

# Create a managed disk
resource "azurerm_managed_disk" "disk" {
  name                 = "${var.project_name}-disk"
  location             = var.region
  resource_group_name  = azurerm_resource_group.rg.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "30" # 30GB minimal size for the image
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "vm" {
    name                  = "${var.project_name}"
    location              = var.region
    resource_group_name   = azurerm_resource_group.rg.name
    network_interface_ids = [azurerm_network_interface.nic.id]
    size                  = "Standard_B2s"
    # size                  = "Standard_DS1_v2"

    # Set VM to Spot
    # priority = "Spot"
    # eviction_policy = "Deallocate"


    os_disk {
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

    computer_name  = "${var.project_name}"
    admin_username = "${var.ssh_key_username}"
    disable_password_authentication = true

    admin_ssh_key {
        username       = "${var.ssh_key_username}"
        public_key     = file(var.ssh_key_pub)
        # public_key     = tls_private_key.sshkey.public_key_openssh
    }

  # # Workaround to wait for vm to be available before executing the playbook
  # provisioner "remote-exec" {
  #   inline = ["sudo apt install python3 -y"]

  #   connection {
  #     host        = "${self.public_ip_address}"
  #     type        = "ssh"
  #     user        = "${var.ssh_key_username}"
  #     private_key = "${file(var.ssh_key_private)}"
  #   }
  # }
  #   # Execute Ansible Playbook
  #   provisioner "local-exec" {
  #   command = " ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i '${self.public_ip_address},' --user ${var.ssh_key_username} --private-key ${var.ssh_key_private} ../ansible/main.yml"
  #   }
}

resource "local_file" "hosts" {
    content  = azurerm_linux_virtual_machine.vm.public_ip_address
    filename = "../ansible/hosts"
}

resource "azurerm_virtual_machine_data_disk_attachment" "attachment" {
  managed_disk_id    = azurerm_managed_disk.disk.id
  virtual_machine_id = azurerm_linux_virtual_machine.vm.id
  lun                = "10"
  caching            = "ReadWrite"
}

resource "azurerm_storage_account" "sa" {
  name                     = "${var.project_name}funcsa"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "asp" {
  name                = "${var.project_name}-asp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
#   kind                = "Linux"
  kind                = "FunctionApp"
  reserved            = true
  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_function_app" "func" {
  name                       = "${var.project_name}-function"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  app_service_plan_id        = azurerm_app_service_plan.asp.id
  storage_account_name       = azurerm_storage_account.sa.name
  storage_account_access_key = azurerm_storage_account.sa.primary_access_key
  os_type                    = "linux"
}