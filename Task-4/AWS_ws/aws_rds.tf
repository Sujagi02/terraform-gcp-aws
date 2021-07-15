resource "aws_db_instance" "aws_rds" {
  depends_on = [
    aws_instance.wp
  ]
  allocated_storage    = 10
  identifier = "wordpress-database"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "wordpress"
  username             = var.db_username
  password             = var.db_pass
  parameter_group_name = "default.mysql5.7"
  publicly_accessible = true
  skip_final_snapshot  = true
}

output "Endpoint_string" {
  value = aws_db_instance.aws_rds.endpoint
}