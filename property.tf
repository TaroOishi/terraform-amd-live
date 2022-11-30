data "akamai_group" "group" {
  group_name  = var.akamai_group.group_name
  contract_id = var.akamai_group.contract_id
}

data "akamai_contract" "contract" {
  group_name = data.akamai_group.group.name
}

data "akamai_property_rules_template" "rules" {
  template_file = abspath("${path.module}/property-snippets/main.json")
  variables {
    name = "cpcode_name"
    value = var.cpcode_name
    type = "string"
  }
  variables {
    name = "cpcode"
    value = replace(akamai_cp_code.amd.id, "cpc_", "")
    type = "number"
  }
  variables {
    name = "mslorigin"
    value = var.mslorigin
    type = "string"
  }
}

resource "akamai_edge_hostname" "amd" {
  product_id    = "prd_Adaptive_Media_Delivery"
  contract_id   = data.akamai_contract.contract.id
  group_id      = data.akamai_group.group.id
  ip_behavior   = "IPV6_COMPLIANCE"
  edge_hostname = var.edge_hostname
  use_cases = jsonencode([
    {
      "option" : "LIVE",
      "type" : "GLOBAL",
      "useCase" : "Segmented_Media_Mode"
    } 
  ])
}

resource "akamai_property" "amd" {
  name        = var.cname_from
  contract_id = data.akamai_contract.contract.id
  group_id    = data.akamai_group.group.id
  product_id  = "prd_Adaptive_Media_Delivery"
  rule_format = "latest"
  hostnames {
    cname_from             = var.cname_from
    cname_to               = akamai_edge_hostname.amd.edge_hostname
    cert_provisioning_type = "CPS_MANAGED"
  }
  rules = data.akamai_property_rules_template.rules.json
}

resource "akamai_property_activation" "amd" {
  property_id = akamai_property.amd.id
  contact     = [var.email]
  version     = akamai_property.amd.latest_version
  network     = upper(var.env)
  note        = ""
}

resource "akamai_cp_code" "amd" {
  name = var.cpcode_name
  group_id = data.akamai_group.group.id
  contract_id = data.akamai_contract.contract.id
  product_id = "prd_Adaptive_Media_Delivery"
}
