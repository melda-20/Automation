variable "username_vsphere" {
  type        = string
  description = "username for vsphere"
}

variable "password_vsphere" {
  type        = string
  description = "password for vsphere"
  sensitive = true
}

variable "url_vsphere" {
  type        = string
  description = "url for vsphere"
}