# terraform-my-iac-project/variables.tf

variable "app_name" {
  description = "Base name for the application resources."
  type        = string
  default     = "my-app"
}

variable "app_replicas" {
  description = "Number of application container replicas."
  type        = number
  default     = 1
}

variable "enable_monitoring" {
  description = "Flag to enable a (simulated) monitoring sidecar."
  type        = bool
  default     = false
}

# HIER DIE FEHLENDEN VARIABLEN HINZUFÜGEN:
variable "frontend_image_name" {
  description = "Docker image for the frontend service (e.g., 'nginx:latest')."
  type        = string
  default     = "nginx:latest" # Oder ein anderer sinnvoller Default
}

variable "frontend_external_port" {
  description = "External port for the frontend service."
  type        = number
  default     = 8080 # Oder ein anderer sinnvoller Default
}

variable "backend_image_name" {
  description = "Docker image for the backend service (e.g., 'node:18-alpine')."
  type        = string
  default     = "node:18-alpine" # Beispiel, passe es an dein Backend-Image an
}

variable "backend_external_port" {
  description = "External port for the backend service."
  type        = number
  default     = 3001 # Oder ein anderer sinnvoller Default
}

# Ggf. weitere Variablen, die du für die Datenbank brauchst, wie in meinem vorherigen Beispiel angedeutet:
variable "db_image_name" {
  description = "Docker image for the database service (e.g., 'postgres:15-alpine')."
  type        = string
  default     = "postgres:15-alpine"
}

variable "db_user" {
  description = "Username for the database."
  type        = string
  default     = "appuser"
  sensitive   = true # Markiere als sensitiv, wenn es sich um echte Credentials handelt
}

variable "db_password" {
  description = "Password for the database user."
  type        = string
  default     = "apppassword" # Setze hier KEINE echten Passwörter für öffentliche Repos!
  sensitive   = true
}

variable "db_name" {
  description = "Name of the database."
  type        = string
  default     = "appdb"
}

# Und die Variablen, die du vielleicht schon hattest, wie project_prefix etc.
variable "project_prefix" {
  description = "A prefix for all resource names."
  type        = string
  default     = "tf-app"
}