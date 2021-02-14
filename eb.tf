resource "aws_elastic_beanstalk_application" "docker-travis" {
  name        = "docker-travis"
  description = "docker-travis"
}

resource "aws_elastic_beanstalk_environment" "docker-travis-prod" {
  name        = "docker-travis-prod"
  application = aws_elastic_beanstalk_application.docker-travis.name
  solution_stack_name = "64bit Amazon Linux 2018.03 v2.16.4 running Docker 19.03.13-ce"
  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = aws_vpc.tenv.id
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = aws_subnet.tenv-public-1.id
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     = "false"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.app-ec2-role.name
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = aws_security_group.J1-SG.id
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t3a.micro"
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = aws_iam_role.elasticbeanstalk-service-role.name
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBScheme"
    value     = "public"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = aws_subnet.tenv-public-1.id
  }
  setting {
    namespace = "aws:elb:loadbalancer"
    name      = "CrossZone"
    value     = "true"
  }
  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "BatchSize"
    value     = "30"
  }
  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "BatchSizeType"
    value     = "Percentage"
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "Availability Zones"
    value     = "Any 2"
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = "1"
  }
  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "RollingUpdateType"
    value     = "Health"
  }
  
}