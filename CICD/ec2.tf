resource "aws_instance" "J1-tenv" {
    ami                         = "ami-0ad398ec67ca188ff"
    availability_zone           = "ap-northeast-2a"
    ebs_optimized               = false
    instance_type               = "t3a.micro"
    monitoring                  = false
    key_name                    = "J1"
    subnet_id                   = aws_subnet.tenv-public-1.id
    vpc_security_group_ids      = [aws_security_group.J1-SG.id]
    associate_public_ip_address = true
    private_ip                  = "10.0.0.10"
    source_dest_check           = true

    root_block_device {
        volume_type           = "gp2"
        volume_size           = 20
        delete_on_termination = true
    }

    tags = {
    Name                        = "J1-tenv"
    }
}