terraform {
  experiments = [variable_validation]

  required_providers {
    azurerm = "~> 2.15.0"
    azuread = "~> 0.10.0"
    random  = "~> 2.2.1"
    null    = "~> 2.1.0"
  }
}


provider "azurerm" {
  features {}
}


data "azurerm_subscription" "primary" {}
data "azurerm_client_config" "current" {}


resource "random_string" "prefix" {
  length  = 4
  special = false
  upper   = false
  number  = false
}

resource "random_string" "alpha1" {
  length  = 1
  special = false
  upper   = false
  number  = false
}

locals {
  landingzone_tag = {
    landingzone = var.launchpad_mode
  }
  tags = merge(var.tags, local.landingzone_tag, { "level" = var.level }, { "environment" = var.environment }, { "rover_version" = var.rover_version })

  prefix             = var.prefix == null ? random_string.prefix.result : var.prefix
  prefix_with_hyphen = local.prefix == "" ? "" : "${local.prefix}-"
  prefix_start_alpha = local.prefix == "" ? "" : "${random_string.alpha1.result}${local.prefix}"
}