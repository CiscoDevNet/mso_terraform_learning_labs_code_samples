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

# Define an MSO Schema VRF Resource.
data "mso_schema_template_vrf" "vrf_obj" {
    schema_id     = data.mso_schema.schema_obj.id
    template      = data.mso_schema.schema_obj.template_name
    name          = var.vrf
    display_name  = var.vrf
}

# Define an MSO Schema BD Resource.
data "mso_schema_template_bd" "bd_obj" {
    schema_id              = data.mso_schema.schema_obj.id
    template_name          = data.mso_schema.schema_obj.template_name
    name                   = var.bd
    display_name           = var.bd
    vrf_name               = data.mso_schema_template_vrf.vrf_obj.name
}

# Define an MSO Contract Resource.
data "mso_schema_template_contract" "contract_internet_web_obj" {
  schema_id                = data.mso_schema.schema_obj.id
  template_name            = data.mso_schema.schema_obj.template_name
  contract_name            = var.contracts
  display_name             = var.contracts
  directives               = ["none"]
}

# Define an MSO Application Profile Resource.
resource "mso_schema_template_anp" "anp_obj" {
  schema_id     = data.mso_schema.schema_obj.id
  template      = data.mso_schema.schema_obj.template_name
  name          = var.anp
  display_name  = var.anp
}

# Define an MSO Application EPG Resource.
resource "mso_schema_template_anp_epg" "web_obj" {
  schema_id         = data.mso_schema.schema_obj.id
  template_name     = data.mso_schema.schema_obj.template_name
  anp_name          = mso_schema_template_anp.anp_obj.name
  name              = var.epgs
  display_name      = var.epgs
  bd_name           = data.mso_schema_template_bd.bd_obj.name
  bd_template_name  = data.mso_schema.schema_obj.template_name
  vrf_name          = data.mso_schema_template_vrf.vrf_obj.name
  vrf_template_name = data.mso_schema.schema_obj.template_name
}

# Associate the EPGs with the contrats
resource "mso_schema_template_anp_epg_contract" "epg_web_c1" {
  schema_id              = data.mso_schema.schema_obj.id
  template_name          = data.mso_schema.schema_obj.template_name
  anp_name               = mso_schema_template_anp.anp_obj.name
  epg_name               = mso_schema_template_anp_epg.web_obj.name
  contract_name          = data.mso_schema_template_contract.contract_internet_web_obj.contract_name
  contract_template_name = data.mso_schema.schema_obj.template_name
  relationship_type      = "provider"
}
