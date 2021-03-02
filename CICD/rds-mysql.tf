resource "aws_db_subnet_group" "mysql-subnet" {
    count = 0
    name = "mysql-subnet-tenv"
    description = "RDS subnet group"
    subnet_ids = [aws_subnet.tenv-public-1.id,aws_subnet.tenv-public-2.id,aws_subnet.tenv-public-3.id]
}

resource "aws_db_parameter_group" "mysql-parameters" {
    count = 0
    name = "mysql-params"
    family = "mysql5.7"
    description = "mysql parameter group"

    parameter {
      name = "max_allowed_packet"
      value = "16777216"
   }

}


resource "aws_db_instance" "mysql" {
  count = 0  
  allocated_storage    = 20    # 20 GB of storage, gives us more IOPS than a lower number
  engine               = "mysql"
  engine_version       = "5.7.31"
  instance_class       = "db.t2.small"    # use micro if you want to use the free tier
  identifier           = "docker-fullstack-mysql"
  name                 = "myapp" # database name
  username             = "root"   # username
  password             = "johnahn777" # password
  db_subnet_group_name = aws_db_subnet_group.mysql-subnet[count.index].name
  parameter_group_name = aws_db_parameter_group.mysql-parameters[count.index].name
  multi_az             = "false"     # set to true to have high availability: 2 instances synchronized with each other
  vpc_security_group_ids = [aws_security_group.Internel-SG.id, aws_security_group.J1-SG.id]
  storage_type         = "gp2"
  # backup_retention_period = 30    # how long you’re going to keep your backups
  availability_zone = aws_subnet.tenv-public-1.availability_zone   # prefered AZ
  final_snapshot_identifier = "mysql-final-snapshot" # final snapshot when executing terraform destroy
  tags = {
      Name = "mysql"
  }
}