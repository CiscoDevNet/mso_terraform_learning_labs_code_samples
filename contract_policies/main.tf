terraform {
  required_providers {
    mso = {
      source = "CiscoDevNet/mso"
    }
  }
}

# Configure the provider with your Cisco APIC credentials.
provider "mso" {
  # APIC Username
  username = var.user.username
  # APIC Password
  password = var.user.password
  # APIC URL
  url      = var.user.url
  insecure = true
}

# Define an MSO Tenant Resource.
data "mso_tenant" "tenant_obj" {
    name         = var.tenant
    display_name = var.tenant
}

# Define an MSO Schema Resource.
data "mso_schema" "schema_obj" {
    template_name = "Template1"
    name          = var.schema
    tenant_id     = data.mso_tenant.tenant_obj.id
}

# Define an MSO Filter Entry Resource.
resource "mso_schema_template_filter_entry" "http_obj" {
  schema_id          = data.mso_schema.schema_obj.id
  template_name      = data.mso_schema.schema_obj.template_name
  name               = var.filter_http
  display_name       = var.filter_http
  entry_name         = "HTTP"
  entry_display_name = "HTTP"
  ether_type         = "ip"
  ip_protocol        = "tcp"
  destination_from   = "http"
  destination_to     = "http"
}

resource "mso_schema_template_filter_entry" "https_obj" {
  schema_id          = data.mso_schema.schema_obj.id
  template_name      = data.mso_schema.schema_obj.template_name
  name               = mso_schema_template_filter_entry.http_obj.name
  display_name       = mso_schema_template_filter_entry.http_obj.display_name
  entry_name         = "HTTPs"
  entry_display_name = "HTTPs"
  ether_type         = "ip"
  ip_protocol        = "tcp"
  destination_from   = "https"
  destination_to     = "https"
}

resource "mso_schema_template_filter_entry" "ssh_obj" {
  schema_id          = data.mso_schema.schema_obj.id
  template_name      = data.mso_schema.schema_obj.template_name
  name               = var.filter_ssh
  display_name       = var.filter_ssh
  entry_name         = "SSH"
  entry_display_name = "SSH"
  ether_type         = "ip"
  ip_protocol        = "tcp"
  destination_from   = "ssh"
  destination_to     = "ssh"
}

# Define an MSO Contract Resource.
resource "mso_schema_template_contract" "contract_internet_web_obj" {
  schema_id                = data.mso_schema.schema_obj.id
  template_name            = data.mso_schema.schema_obj.template_name
  contract_name            = var.contracts
  display_name             = var.contracts
  filter_relationships     = {
    filter_schema_id     = data.mso_schema.schema_obj.id
    filter_name          = mso_schema_template_filter_entry.http_obj.name
    filter_template_name = data.mso_schema.schema_obj.template_name
  }
  directives               = ["none"]
}

# Define an MSO Contract Filter Resource.
resource "mso_schema_template_contract_filter" "contract_internet_web_ssh_obj" {
  schema_id     = data.mso_schema.schema_obj.id
  template_name = data.mso_schema.schema_obj.template_name
  contract_name = mso_schema_template_contract.contract_internet_web_obj.contract_name
  filter_name   = mso_schema_template_filter_entry.ssh_obj.name
  filter_type   = "bothWay"
  directives    = ["none"]
}