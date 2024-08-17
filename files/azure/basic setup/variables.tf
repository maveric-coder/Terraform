variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "location" {
  type        = string
  description = "resource location"
}
variable "storage_account_name" {
  type        = string
  description = "storage account name"
}

variable "environment" {
  type        = string
  description = "environment either produnction or developement"
}