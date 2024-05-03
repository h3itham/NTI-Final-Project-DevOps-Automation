# CREATE JENKINS INSTANCE 
resource "aws_instance" "jenkins" {
  ami           = var.srv_img
  instance_type = var.srv_type
  subnet_id     = var.public_subnet_1_id
  key_name      = var.key_name 
  iam_instance_profile = aws_iam_instance_profile.cloudwatch_agent_profile.name
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
  subnet_id     = var.public_subnet_2_id
  iam_instance_profile = aws_iam_instance_profile.cloudwatch_agent_profile.name
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

# IAM ROLE FOR CLOUDWATCH AGENT
resource "aws_iam_role" "cloudwatch_agent_role" {
  name               = "cloudwatch-agent-role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action    = "sts:AssumeRole"
    }]
  })
}

# IAM POLICY FOR CLOUDWATCH AGENT
resource "aws_iam_policy" "cloudwatch_agent_policy" {
  name   = "cloudwatch-agent-policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "cloudwatch:PutMetricData",
        "logs:PutLogEvents",
        "logs:CreateLogStream"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

# ATTACH IAM POLICY TO IAM ROLE
resource "aws_iam_role_policy_attachment" "cloudwatch_agent_attachment" {
  role       = aws_iam_role.cloudwatch_agent_role.name
  policy_arn = aws_iam_policy.cloudwatch_agent_policy.arn
}
# IAM INSTANCE PROFILE
resource "aws_iam_instance_profile" "cloudwatch_agent_profile" {
  name = "cloudwatch-agent-profile"
  role = aws_iam_role.cloudwatch_agent_role.name
}

# GENERTEA THE INVENTORY FILE FOR ANSIBLE 
resource "local_file" "inventory" {
  filename = "../Ansible/inventory"
  content = <<-EOT
[jenkins]
${aws_instance.jenkins.public_ip}
[bastion]
${aws_instance.bastion.public_ip}
EOT
}