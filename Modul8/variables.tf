#resource group variables 
variable "rg_location" {
  type        = string
  description = "Resource group location"
  default     = "westeurope"
}
variable "rg_name" {
  type        = string
  description = "Resource group name"
  default     = "rg-mod8-rs"
}
variable "sa_name" {
  type        = string
  description = "Resource group location"
  default     = "samod8rs"
}
variable "source_content" {
  type        = string
  description = "Source content for the index.html file"
  default     = "<h1>Web page created with Terraform in workspace:</h1>"
}

variable "index_document" {
  type        = string
  description = "Name for the index document"
  default     = "index.html"
}