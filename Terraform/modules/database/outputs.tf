# PRIMARY DATABASE ADDRESSS 
output "dbhost" {
  value = aws_db_instance.primary.address
}

