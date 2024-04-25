# DATABASE SECURITY GROUP 
resource "aws_security_group" "rds-SG" {
  name        = "rds-SG"
  vpc_id = var.vpc_id  
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
  tags = {
    Name = "RDS-SG"
  }
}

# RDS SUBNET GROUP
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
 
  subnet_ids = [var.db_subnet_1_id, var.db_subnet_2_id]
  tags = {
    Name = "database subnetes"
  }
}

# MYSQL RDS DATABASE 

resource "aws_db_instance" "primary" {
  identifier             = "djangodb"
  allocated_storage      = var.allocated_storage
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  multi_az               = false  
  db_name                = var.dbname 
  username               = var.dbusername
  password               = var.dbpassword 
  publicly_accessible    = true 
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds-SG.id]
  skip_final_snapshot    = true  
}
