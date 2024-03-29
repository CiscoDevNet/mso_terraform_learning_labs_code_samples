variable "user" {
  description = "Login information"
  type        = map
  default     = {
    username = "admin"
    password = "1vtG@lw@y"
    url      = "https://10.10.20.60"
  }
}
variable "tenant" {
    type        = string
    default     = "js_10018"
    description = "The MSO tenant to use for this configuration"
}

variable "schema" {
    type    = string
    default = "terraform_schema"
}

variable "vrf" {
    type    = string
    default = "prod_vrf"
}
variable "bd" {
    type    = string
    default = "prod_bd"
}
