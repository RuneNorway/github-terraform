variable "rg_backend_name" {
  type        = string
  description = "Resource group backend name"
}
variable "rg_backend_location" {
  type        = string
  description = "Resource group backend location"
}
variable "sa_backend_name" {
  type        = string
  description = "Storage account backend name"
}
variable "sc_backend_name" {
  type        = string
  description = "Storage Container backend name"
}
variable "kv_backend_name" {
  type        = string
  description = "keyvault backend name"
}

variable "sa_backend_accesskey_name" {
  type        = string
  description = "Storage Container access key backend name"
}