# modules/app_service/main.tf
resource "docker_container" "service_container" {
  name  = var.container_name
  image = var.image_name
  ports {
    internal = var.internal_port
    external = var.external_port
  }
  # ... ggf. Netzwerkanschluss, Volumes etc.
}