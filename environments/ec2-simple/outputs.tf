output "EC2_public_IP" {
  value = aws_instance.web.public_ip
}
