resource "aws_db_subnet_group" "postgresql-subnet" {
    count = var.instance_count
    name = "postgresql-subnet-tenv"
    description = "RDS subnet group"
    subnet_ids = [aws_subnet.tenv-public-1.id,aws_subnet.tenv-public-2.id,aws_subnet.tenv-public-3.id]
}

resource "aws_db_parameter_group" "postgresql-parameters" {
    count = var.instance_count
    name = "postgresql-params"
    family = "postgres13"
    description = "postgresql parameter group"
}

resource "aws_db_instance" "postgresql" {
  count = var.instance_count  
  allocated_storage    = 20    # 20 GB of storage, gives us more IOPS than a lower number
  engine               = "postgres"
  engine_version       = "13.1"
  instance_class       = "db.t3.small"    # postgresql nosupport t2..
  identifier           = "django-postgresql"
  name                 = "postgre" # database name
  username             = "postgres"   # username
  password             = var.RDS_PASSWD # password
  db_subnet_group_name = aws_db_subnet_group.postgresql-subnet[count.index].name
  parameter_group_name = aws_db_parameter_group.postgresql-parameters[count.index].name
  multi_az             = "false"     # set to true to have high availability: 2 instances synchronized with each other
  vpc_security_group_ids = [aws_security_group.Internel-SG.id, aws_security_group.J1-SG.id]
  storage_type         = "gp2"
  # backup_retention_period = 30    # how long you’re going to keep your backups
  availability_zone = aws_subnet.tenv-public-1.availability_zone   # prefered AZ
  final_snapshot_identifier = "postgresql-final-snapshot" # final snapshot when executing terraform destroy
  tags = {
      Name = "postgresql"
  }
}