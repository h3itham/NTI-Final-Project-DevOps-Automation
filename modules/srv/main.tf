# CREATE JENKINS INSTANCE 
resource "aws_instance" "jenkins" {
  ami           = var.srv_img
  instance_type = var.srv_type
  subnet_id     = var.public_subnet_1_id
  key_name      = var.key_name 
  tags = {
    Name = "jenkins" 
  }
  security_groups = [aws_security_group.jenkins-sg.name]
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
   security_groups = [aws_security_group.bastion-sg.name] 
}

# CREATE SECURITY GROUP FOR JENKINS 
resource "aws_security_group" "jenkins-sg" {
  name        = "jenkins-sg" 
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
