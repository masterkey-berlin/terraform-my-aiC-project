# terraform-my-iac-project/outputs.tf

output "frontend_service_container_id" {
  description = "ID of the frontend service container."
  value       = module.frontend_service.container_id # Korrigierte Referenz
}

output "frontend_application_url" {
  description = "URL to access the frontend application."
  value       = "http://localhost:${module.frontend_service.exposed_port}" # Korrigierte Referenz
}

# Optional: Outputs für den Backend-Service, falls gewünscht
output "backend_service_container_id" {
  description = "ID of the backend service container."
  value       = module.backend_service.container_id
}

output "backend_service_internal_ip" {
  description = "Internal IP of the backend service container."
  value       = module.backend_service.internal_ip_address # Annahme: Dein Modul gibt dies aus
}

# Output für den Namen des Docker-Netzwerks (Beispiel, falls in main.tf definiert)
# output "application_network_name" {
#   description = "Name of the created Docker network."
#   value       = docker_network.app_network.name # Annahme: Ressource docker_network.app_network existiert in main.tf
# }