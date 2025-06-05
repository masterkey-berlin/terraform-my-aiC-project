locals {
  network_name       = "${var.app_name}-network"
  container_base_name = var.app_name
  common_tags = {
    Environment = "development"
    Project     = var.app_name
  }
}