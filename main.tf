# DEINE_REPO_WURZELVERZEICHNIS/terraform-my-iac-project/main.tf

# ... (deine docker_network Definition etc.) ...

module "frontend_service" {
  source = "./modules/app_service" # Pfad zu deinem Modul

  container_name = "${local.container_base_name}-frontend"
  image_name     = var.frontend_image_name # Annahme: Variable in deiner Haupt-variables.tf
  internal_port  = 80
  external_port  = var.frontend_external_port # Annahme: Variable in deiner Haupt-variables.tf
  # Ggf. weitere Parameter wie:
  # networks_advanced = [{ name = docker_network.app_network.name }]
  # env_vars          = ["API_URL=http://${module.backend_service.internal_ip_address}:3000"] # Beispiel für Abhängigkeit
}

module "backend_service" {
  source = "./modules/app_service"

  container_name = "${local.container_base_name}-backend"
  image_name     = var.backend_image_name # Annahme: Variable
  internal_port  = 3000
  external_port  = var.backend_external_port # Annahme: Variable
  # networks_advanced = [{ name = docker_network.app_network.name }]
}

# In deiner Haupt-outputs.tf könntest du dann auf die Modul-Outputs zugreifen:
# output "frontend_container_id" {
#   value = module.frontend_service.container_id
# }
# output "frontend_url" {
#   value = "http://localhost:${module.frontend_service.exposed_port}"
# }