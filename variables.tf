variable config_path {
  description = "Path to base configuration directory"
  type        = string
}

variable force_update {
  description = "Whether or not to force update the ports using a timestamp QS"
  type        = bool
  default     = false
}
