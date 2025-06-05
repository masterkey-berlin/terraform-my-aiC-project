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