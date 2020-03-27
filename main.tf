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

data "azurerm_resource_group" "main" {
  name = "${var.resource_group_name}"
}

data "azurerm_virtual_machine" "main" {
  name                = "${var.virtual_machine_name}"
  resource_group_name = "${data.azurerm_resource_group.main.name}"
}

resource "azurerm_virtual_machine_extension" "linux" {
  count                      = "${lower(var.os_type) == "linux" ? 1 : 0}"
  name                       = "${var.virtual_machine_name}-run-command"
  location                   = "${data.azurerm_resource_group.main.location}"
  resource_group_name        = "${data.azurerm_resource_group.main.name}"
  virtual_machine_name       = "${data.azurerm_virtual_machine.main.name}"
  publisher                  = "Microsoft.CPlat.Core"
  type                       = "RunCommandLinux"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
  protected_settings         = "${jsonencode(local.settings_linux)}"
  tags                       = "${var.tags}"
}

resource "azurerm_virtual_machine_extension" "windows" {
  count                      = "${lower(var.os_type) == "windows" ? 1 : 0}"
  name                       = "${var.virtual_machine_name}-run-command"
  location                   = "${data.azurerm_resource_group.main.location}"
  resource_group_name        = "${data.azurerm_resource_group.main.name}"
  virtual_machine_name       = "${data.azurerm_virtual_machine.main.name}"
  publisher                  = "Microsoft.CPlat.Core"
  type                       = "RunCommandWindows"
  type_handler_version       = "1.1"
  auto_upgrade_minor_version = true
  settings                   = "${jsonencode(local.settings_windows)}"
  tags                       = "${var.tags}"
}
