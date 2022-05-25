
#######
# RDS #
#######
resource "aws_db_instance" "default" {
  allocated_storage      = 10
  db_subnet_group_name   = module.vpc.database_subnet_group
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  engine                 = var.db_engine
  engine_version         = var.db_engine_version
  instance_class         = var.db_class
  db_name                   = var.db_name
  username               = var.db_username
  password               = var.db_password
  skip_final_snapshot    = true # Only in Test. Would keep final snapshot for prod
}