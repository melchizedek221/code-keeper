
output "gitlab_instance_ip" {
  value = aws_instance.gitlab.public_ip
}
