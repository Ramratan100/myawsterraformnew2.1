output "bastion_ip" {
  value = aws_instance.bastion_host.public_ip
}

output "mysql_private_ip" {
  value = aws_instance.mysql_instance.private_ip
}
