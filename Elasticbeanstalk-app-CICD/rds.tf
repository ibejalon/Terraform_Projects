resource "aws_db_subnet_group" "mariadb-subnet" {                   # the database type to be used for the app
  name        = "mariadb-subnet"
  description = "RDS subnet group"
  subnet_ids  = [aws_subnet.main-private-1.id, aws_subnet.main-private-2.id]     # the private subnets in the VPC where DB is going to attached to
}

resource "aws_db_parameter_group" "mariadb-parameters" {
  name        = "mariadb-params"
  family      = "mariadb10.1"
  description = "MariaDB parameter group"

  parameter {
    name  = "max_allowed_packet"
    value = "16777216"
  }
}

resource "aws_db_instance" "mariadb" {
  allocated_storage         = 100 # in GB
  engine                    = "mariadb"
  engine_version            = "10.2.21"
  instance_class            = "db.t2.micro" # because I am using free tier
  identifier                = "mariadb"
  name                      = "mydatabase"     # database name
  username                  = "root"           # username
  password                  = var.RDS_PASSWORD # password
  db_subnet_group_name      = aws_db_subnet_group.mariadb-subnet.name
  parameter_group_name      = aws_db_parameter_group.mariadb-parameters.name
  multi_az                  = "true" 
  vpc_security_group_ids    = [aws_security_group.allow-mariadb.id]
  storage_type              = "gp2"
  backup_retention_period   = 30                                          
  availability_zone         = aws_subnet.main-private-2.availability_zone # since this will the main AZ
  final_snapshot_identifier = "mariadb-final-snapshot"                    # needed for when executing terraform destroy
  tags = {
    Name = "mariadb-instance"
  }
}

