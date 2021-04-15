output "tls_private_key" {
    value = tls_private_key.minesshkey.private_key_pem
}
output "public_ip" {
    value = azurerm_linux_virtual_machine.minevm.public_ip_address
}