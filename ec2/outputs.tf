output "first_centos_private_ip" {
  value = aws_instance.tsj_centos_test[0].private_ip
}
