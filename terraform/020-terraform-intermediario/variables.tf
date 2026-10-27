variable "regiao" {
  description = "Região da AWS"
  type        = string
  default     = "us-east-1"
}

variable "tipo_instancia" {
  description = "Tipo da instância EC2"
  type        = string
  default     = "t2.micro"
}

variable "nome_servidor" {
  description = "Nome da tag da instância"
  type        = string
  default     = "payfast-servidor-tf"
}
