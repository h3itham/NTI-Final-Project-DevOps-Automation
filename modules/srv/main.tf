# CREATE JENKINS INSTANCE 
resource "aws_instance" "jenkins" {
  ami           = var.srv_img
  instance_type = var.srv_type
  subnet_id     = var.public_subnet_1_id
  key_name      = var.key_name 
  tags = {
    Name = "jenkins" 
    Backup  = "true"
  }
  security_groups = [aws_security_group.jenkins-sg.id]
  depends_on = [aws_security_group.jenkins-sg]
  associate_public_ip_address = true 
}

# CREATE BASITION HOST, ANSIBLE AND KUBECTL INSTANCE 
resource "aws_instance" "bastion" {
  ami           = var.srv_img
  instance_type = var.srv_type
  key_name      = var.key_name 
  subnet_id     = var.public_subnet_1_id
  tags = {
    Name = "bastion" 
  }
   security_groups = [aws_security_group.bastion-sg.id] 
   depends_on = [aws_security_group.bastion-sg]
   associate_public_ip_address = true 
}

# CREATE SECURITY GROUP FOR JENKINS 
resource "aws_security_group" "jenkins-sg" {
  name        = "jenkins-sg" 
  vpc_id      = var.vpc_id 
  ingress {
    from_port   = 22 
    to_port     = 22
    protocol    = "tcp" 
    cidr_blocks = ["0.0.0.0/0"] 
  }
  ingress {
    from_port   = 8080 
    to_port     = 8080
    protocol    = "tcp" 
    cidr_blocks = ["0.0.0.0/0"] 
  }
   ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp" 
    cidr_blocks = ["0.0.0.0/0"] 
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" 
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# CREATE SECURITY GROUP FOR BASION HOST 
resource "aws_security_group" "bastion-sg" {
  name        = "bastion-sg" 
  vpc_id      = var.vpc_id 
  ingress {
    from_port   = 22 
    to_port     = 22
    protocol    = "tcp" 
    cidr_blocks = ["0.0.0.0/0"] 
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" 
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# CREATE INVETORY FILE FOR JENKINS 
resource "local_file" "inventory_file" {
  filename = "../../ansible/inventory"
  content  = <<-EOT
[jenkins]
${aws_instance.jenkins.public_ip}

EOT
}
