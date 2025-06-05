output "web_app_container_id" {
  description = "ID of the web application container."
  value       = module.web_app.container_id # Annahme: Modul gibt container_id aus
}
output "application_url" {
  description = "URL to access the web application."
  value       = "http://localhost:${module.web_app.exposed_port}" # Annahme: Modul gibt exposed_port aus
}