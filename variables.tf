variable "resource_group_name" {
  description = "The name of the resource group."
}

variable "virtual_machine_name" {
  description = "The name of the virtual machine."
}

variable "os_type" {
  description = "Specifies the operating system type."
}

variable "command" {
  default     = ""
  description = "Command to be executed."
}

variable "script" {
  default     = ""
  description = "Script to be executed."
}

variable "file_uris" {
  type        = "list"
  default     = []
  description = "List of files to be downloaded."
}

variable "timestamp" {
  default     = ""
  description = "An integer, intended to trigger re-execution of the script when changed."
}

variable "tags" {
  default     = {}
  description = "A mapping of tags to assign to the extension."
}
