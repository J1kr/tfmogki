resource "aws_elastic_beanstalk_application" "tdocker" {
  count       =  var.instance_count
  name        = "tdocker"
  description = "tdocker"
}

resource "aws_elastic_beanstalk_environment" "tdocker-env" {
  count       = var.instance_count
  name        = "tdocker-env"
  application = aws_elastic_beanstalk_application.tdocker[count.index].name
  solution_stack_name = "64bit Amazon Linux 2018.03 v2.25.1 running Multi-container Docker 19.03.13-ce (Generic)"
  wait_for_ready_timeout ="8m"
  
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
    value     = "true"
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
    name      = "SecurityGroups"
    value     = aws_security_group.Internel-SG.id
  }
  
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "EC2KeyName"
    value     = "J1"
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
    value     = "subnet-0c05032dfee7b2b4b,subnet-0c1c48c2b79c67be9,subnet-0cdbc99cfcf00d8a1"
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
    value     = "Any"
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
    setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "RDS_USER"
    value     = aws_db_instance.postgresql[count.index].username
  }
  
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "RDS_PASSWORD"
    value     = aws_db_instance.postgresql[count.index].password
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "RDS_NAME"
    value     = aws_db_instance.postgresql[count.index].name
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "RDS_PORT"
    value     = aws_db_instance.postgresql[count.index].port
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "RDS_HOST"
    value     = aws_db_instance.postgresql[count.index].address
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "SENTRY_URL"
    value     = var.SENTRY_URL
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "SES_USERNAME"
    value     = var.SES_USERNAME
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "SES_PASSWORD"
    value     = var.SES_PASSWORD
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "GH_ID"
    value     = var.GH_ID
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "KAKAO_ID"
    value     = var.KAKAO_ID
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "GH_SECRET"
    value     = var.GH_SECRET
  }

}

resource "aws_route53_record" "dev_mogki_com_cname" {
  count   = var.instance_count
  zone_id = aws_route53_zone.mogki_com.zone_id
  name    = "dev.mogki.com"
  type    = "CNAME"
  ttl     = "60"
  records = [aws_elastic_beanstalk_environment.tdocker-env[0].cname]
  
}