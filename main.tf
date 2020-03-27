# AzureRm Run Command Updated for AzureRM v2.0 

# Local Variables
locals {
  settings_windows = {
    script   = "${compact(concat(list(var.command), split("\n", var.script)))}"
    fileUris = "${var.file_uris}"
  }

  settings_linux = {
    commandToExecute = "${var.command}"
    fileUris         = "${var.file_uris}"
    script           = "${base64encode(var.script)}"
  }
}

# Data Resource Group
data "azurerm_resource_group" "main" {
  name = "${var.resource_group_name}"
}

# Linux Virtual Machine
data "azurerm_linux_virtual_machine" "linux_main" {
  id                  = "${var.virtual_machine_id}"
  resource_group_name = "${data.azurerm_resource_group.main.name}"
}

# Windows Virtual Machine
data "azurerm_windows_virtual_machine" "windows_main" {
  id                  = "${var.virtual_machine_id}"
  resource_group_name = "${data.azurerm_resource_group.main.name}"
}

# Azure Virtual Machine Extension for Linux
resource "azurerm_virtual_machine_extension" "linux" {
  count                      = "${lower(var.os_type) == "linux" ? 1 : 0}"
  name                       = "${var.virtual_machine_name}-run-command"
  location                   = "${data.azurerm_resource_group.main.location}"
  resource_group_name        = "${data.azurerm_resource_group.main.name}"
  virtual_machine_id         = "${data.azurerm_linux_virtual_machine.linux_main.id}"
  publisher                  = "Microsoft.CPlat.Core"
  type                       = "RunCommandLinux"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
  protected_settings         = "${jsonencode(local.settings_linux)}"
  tags                       = "${var.tags}"
}

# Azure Virtual Machine Extension for Windows
resource "azurerm_virtual_machine_extension" "windows" {
  count                      = "${lower(var.os_type) == "windows" ? 1 : 0}"
  name                       = "${var.virtual_machine_name}-run-command"
  location                   = "${data.azurerm_resource_group.main.location}"
  resource_group_name        = "${data.azurerm_resource_group.main.name}"
  virtual_machine_id         = "${data.azurerm_virtual_machine.windows_main.id}"
  publisher                  = "Microsoft.CPlat.Core"
  type                       = "RunCommandWindows"
  type_handler_version       = "1.1"
  auto_upgrade_minor_version = true
  settings                   = "${jsonencode(local.settings_windows)}"
  tags                       = "${var.tags}"
}
