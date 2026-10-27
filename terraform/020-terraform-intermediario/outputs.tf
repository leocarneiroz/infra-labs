output "ip_publico" {
  description = "IP público da instância criada"
  value       = aws_instance.payfast_web.public_ip
}
