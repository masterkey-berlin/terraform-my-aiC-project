# modules/app_service/variables.tf

variable "container_name" {
  description = "The name for the Docker container."
  type        = string
  # Kein Default-Wert hier, da der Name wahrscheinlich immer spezifisch sein soll,
  # wenn das Modul aufgerufen wird. Man könnte aber einen anbieten.
}

variable "image_name" {
  description = "The Docker image to use for the container (e.g., 'nginx:latest')."
  type        = string
  # Kein Default hier, da das Image essentiell ist.
}

variable "internal_port" {
  description = "The internal port the application inside the container listens on."
  type        = number
  # Default könnte sinnvoll sein, wenn deine Services oft denselben internen Port nutzen (z.B. 80 für Webserver).
  # default     = 80
}

variable "external_port" {
  description = "The external port on the host to map to the container's internal port. Set to 0 for a random port."
  type        = number
  # Kein Default hier, um eine bewusste Entscheidung im aufrufenden Code zu erzwingen,
  # oder einen Default wie 0 für einen zufälligen Port, falls das gewünscht ist.
}

# Optionale, aber oft nützliche zusätzliche Variablen für ein Container-Modul:

variable "restart_policy" {
  description = "Restart policy for the container (e.g., 'no', 'on-failure', 'always')."
  type        = string
  default     = "no" # Oder "unless-stopped" oder "always" je nach Präferenz
}

variable "env_vars" {
  description = "A list of environment variables to set in the container, e.g., ['VAR1=value1', 'VAR2=value2']."
  type        = list(string)
  default     = []
}

variable "networks_advanced" {
  description = "Advanced network configuration. List of network objects to connect to."
  type = list(object({
    name = string # Name des Docker-Netzwerks
    # alias   = optional(string) # Alias für den Container in diesem Netzwerk
    # ip_address = optional(string) # Feste IP-Adresse in diesem Netzwerk (mit Vorsicht verwenden)
  }))
  default = []
  # Hinweis: Für einfache Netzwerkverbindungen (nur Name/ID) könnte man auch einen einfacheren Typ wie list(string) für network_ids nehmen.
  # Dieses Objekt ist flexibler, wenn man Aliase oder IPs pro Netzwerk setzen will.
  # Für die Aufgabe reicht oft eine einfachere Variante:
  # variable "network_name" {
  #   description = "Name of the Docker network to connect the container to."
  #   type        = string
  #   default     = null # oder "bridge"
  # }
}

variable "volumes" {
  description = "A list of volume mounts for the container, e.g., ['my-volume:/path/in/container', '/host/path:/path/in/container']."
  type        = list(string)
  default     = []
}

variable "labels" {
  description = "A map of labels to apply to the container."
  type        = map(string)
  default     = {}
}