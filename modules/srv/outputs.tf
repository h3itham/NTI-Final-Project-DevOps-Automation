# CREATE INVETORY FILE FOR JENKINS 
resource "local_file" "inventory_file" {
  filename = "../../ansible/inventory" 
  content  = <<-EOT
[jenkins]
${aws_instance.jenkins.public_ip}
EOT
}