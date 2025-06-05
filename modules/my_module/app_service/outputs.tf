# modules/app_service/outputs.tf

output "container_id" {
  description = "The ID of the created Docker container."
  value       = docker_container.service_container.id
}

output "container_name_actual" {
  description = "The actual name of the container as assigned by Docker (might differ from input if conflicts)."
  value       = docker_container.service_container.name
}

output "internal_ip_address" {
  description = "The internal IP address of the container within its Docker network (if connected to a user-defined network and inspectable)."
  # Dieser Wert ist oft nur verfügbar, wenn der Container an ein Netzwerk angeschlossen ist
  # und Terraform ihn inspizieren kann. Die Verfügbarkeit hängt vom Docker Provider und Setup ab.
  # Für das erste Netzwerk, an das der Container angeschlossen ist:
  value       = length(docker_container.service_container.network_data) > 0 ? docker_container.service_container.network_data[0].ip_address : null
  # Alternativ, wenn du eine spezifische Netzwerkverbindung im Modul erstellst oder eine network_alias verwendest,
  # könntest du versuchen, die IP gezielter abzurufen.
}

output "exposed_port" {
  description = "The external port the container is mapped to on the host."
  # Zugriff auf den ersten (und in deinem Modul-main.tf einzigen) Port-Block
  value       = docker_container.service_container.ports[0].external
}