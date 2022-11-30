#########################
# Akamai Property
#########################

variable "edgerc_path" {
  type    = string
  default = "~/.edgerc"
}

variable "config_section" {
  type    = string
  default = "default"
}

variable "env" {
  type    = string
  default = "production"
}

# Group NameとContract ID(先頭にはctr_が必要)を記載する

variable "akamai_group" {
  default = {
    group_name = "Example Contract"
    contract_id = "ctr_Contract-123"
  }
}

# CP Code Nameに任意の名前を設定する

variable "cpcode_name" {
  default = "livestreaming-example"
}

# Akamaiに割り当てるHostnameを指定する

variable "cname_from" {
  default = "livestreaming-example.akamaized.net"
}

# Emailを記載する

variable "email" {
  default = "admin@example.com"
}

# EdgeHostnameを記載する

variable "edge_hostname" {
  default = "livestreaming-example.akamaized.net"
}

# MSL4 のオリジンを記載する

variable "mslorigin" {
  default = "014-dn001-mslexampleorigin.akamaiorigin.net"
}
