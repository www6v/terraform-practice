provider "aws" {
  profile = "aws-profile"
  region  = "eu-west-1"
}

resource "aws_key_pair" "mykey" {
  key_name   = "deployer-key"
  public_key = file("id_rsa.pub")
}

resource "aws_instance" "tsj_centos_test" {
  count = 1
  ami           = data.aws_ami.latest_centos.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.mykey.key_name
  # vpc_security_group_ids = ["sg-0123456789"]
  # subnet_id              = "subnet-0123456789"
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("id_rsa")
    host        = self.public_ip
  }
  tags = {
    Name = "tsj_centos_linux"
    os   = "centos"
    role = "ec2"
  }
  root_block_device {
    volume_size           = 30
    delete_on_termination = true
  }
  user_data = "${file("init.sh")}"
}
