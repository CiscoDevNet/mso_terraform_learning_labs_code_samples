terraform {
  required_providers {
    mso = {
      source = "CiscoDevNet/mso"
    }
  }
}

# Configure the provider with your Cisco MSO credentials.
provider "mso" {
  # MSO Username
  username = var.user.username
  # MSO Password
  password = var.user.password
  # MSO URL
  url      = var.user.url
  insecure = true
}

# Define an MSO REST API Resource.
resource "mso_rest" "sample_rest" {
    path = "/api/v1/tenants"
    method = "POST"
    payload = <<EOF
{
    "name": "tenant_rest",
    "displayName": "tenant_rest",
    "userAssociations": [{
        "userId": "{{ query_user_id.current.id }}"
    }]
}
EOF

}