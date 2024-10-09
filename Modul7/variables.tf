#resource group variables 
variable "rg_location" {
    type = string
    description = "Resource group location"
  
}
variable "rg_name" {
    type = string
    description = "Resource group name"
  
}
variable "sa_name" {
    type = string
    description = "Resource group location"
  
}
variable "source_content" {
    type = string
    description = "Source content for the index.html file"
}

variable "index_document" {
    type = string
    description = "Name for the index document"
}