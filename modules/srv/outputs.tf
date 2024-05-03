# Inside modules/srv/outputs.tf

output "jenkins_ip" {
  value = aws_instance.jenkins.public_ip
}

output "bastion_ip" {
  value = aws_instance.bastion.public_ip
}