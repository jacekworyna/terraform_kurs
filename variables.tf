variable "user_object_id" {
  description = "(Opcjonalne) Object ID (GUID) Twojego użytkownika w Azure AD. Zostaw puste string ('') aby nie tworzyć polityki dla użytkownika."
  type        = string
  default     = ""
}

variable "key_vault_name" {
  description = "Nazwa Key Vault (jeśli chcesz zmienić domyślną)"
  type        = string
  default     = "kvnameofkvhere"
}
