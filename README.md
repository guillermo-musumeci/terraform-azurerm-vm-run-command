# Terraform AzureRM VM Run Command
Execute commands in Linux and Windows machines

Cloned from https://github.com/innovationnorway/terraform-azurerm-vm-run-command

-----------

# Run Commmand in Azure VM

Uses the VM agent to run PowerShell scripts (Windows) or shell scripts (Linux) within an Azure VM. It can be used to bootstrap/install software or run administrative tasks.

## Example Usage

### Install cURL (Linux)

```hcl
module "run_command" {
  source               = "innovationnorway/vm-run-command/azurerm"
  resource_group_name  = "${azurerm_resource_group.main.name}"
  virtual_machine_name = "${azurerm_virtual_machine.main.name}"
  os_type              = "linux"

  command = "apt-get install -y curl"
}
```

### Install Chocolatey (Windows)

```hcl
module "run_command" {
  source               = "innovationnorway/vm-run-command/azurerm"
  resource_group_name  = "${azurerm_resource_group.main.name}"
  virtual_machine_name = "${azurerm_virtual_machine.main.name}"
  os_type              = "windows"

  command = "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))"
}
```

### Install Git (Linux)

```hcl
module "run_command" {
  source               = "innovationnorway/vm-run-command/azurerm"
  resource_group_name  = "${azurerm_resource_group.main.name}"
  virtual_machine_name = "${azurerm_virtual_machine.main.name}"
  os_type              = "linux"

  script = <<EOF
add-apt-repository -y ppa:git-core/ppa
apt-get update
apt-get install -y git
EOF
}
```

### Install Updates (Windows)

```hcl
module "run_command" {
  source               = "innovationnorway/vm-run-command/azurerm"
  resource_group_name  = "${azurerm_resource_group.main.name}"
  virtual_machine_name = "${azurerm_virtual_machine.main.name}"
  os_type              = "windows"

  script = <<EOF
Install-Module -Name PSWindowsUpdate -Force -AllowClobber
Get-WUInstall -WindowsUpdate -AcceptAll -UpdateType Software -IgnoreReboot
Get-WUInstall -MicrosoftUpdate -AcceptAll -IgnoreUserInput -IgnoreReboot
EOF
}
```

## Arguments

| Name | Type | Description |
| --- | --- | --- |
| `resource_group_name` | `string` | The name of the resource group. |
| `virtual_machine_name` | `string` | The name of the virtual machine. |
| `os_type` | `string` | The name of the operating system. Possible values are: `linux` and `windows`. |
| `command` | `string` | The command to be executed. |
| `script` | `string` | The script to be executed. Either this or `command` should be specified, but not both. |
| `file_uris` | `list` | List of URLs for files to be downloaded. |
| `timestamp` | `string` | Change this value to trigger a rerun of the script. Any integer value is acceptable, it must only be different than the previous value. |
