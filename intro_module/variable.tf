variable "user" {
  description = "Login information"
  type        = map
  default     = {
    username = "admin"
    password = "C1sco!234567"
    url      = "https://10.10.20.60"
  }
}
