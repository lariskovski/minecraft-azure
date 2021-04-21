# AUTH CONFIG
variable "client_id" {
  type = string
}
variable "client_secret" {
  type = string
}
variable "subscription_id" {
  type = string
}
variable "tenant_id" {
  type = string
}

variable "region" {
  type = string
  default = "eastus"
}

variable "project_name" {
  type = string
  default = "minecraft"
}

variable "rg_name" {
  type = string
  default = "minecraft-2"
}

variable "ssh_key_username" {
  type = string
  default = "azureuser"
}

variable "ssh_key_pub" {
  type = string
  default = "~/.ssh/azure-mine.pub"
}

variable "ssh_key_private" {
  type = string
  default = "~/.ssh/azure-mine"
}