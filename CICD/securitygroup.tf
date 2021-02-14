resource "aws_security_group" "J1-SG" {
  vpc_id = aws_vpc.tenv.id
  name = "J1-SG"
  description = "security group for my WorkPlace"
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["123.214.11.177/32" , "118.32.24.198/32"]
  } 


  tags = {
    Name = "J1-SG"
  }
}
/* resource "aws_security_group" "allow-mariadb" {
  vpc_id = aws_vpc.main.id
  name = "allow-mariadb"
  description = "allow-mariadb"
  ingress {
      from_port = 3306
      to_port = 3306
      protocol = "tcp"
      security_groups = [aws_security_group.app-prod.id]              # allowing access from our example instance
  }
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      self = true
  }
  tags = {
    Name = "allow-mariadb"
  }
} */