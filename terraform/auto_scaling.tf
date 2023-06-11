# ---------------------------
# WEBサーバ Auto Scaling
# ---------------------------
resource "aws_key_pair" "web_ec2_key" {
  key_name   = "web_ec2_access_key"
  public_key = file("./ec2_keys/web_ec2_access_key.pub")
}

resource "aws_launch_configuration" "web_ec2_launch_config" {
  name          = "web_ec2_launch_config"
  image_id      = "ami-0f61bef4a872466a6"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.web_ec2_key.key_name
  user_data = file("./params/initialize.sh")
  }

resource "aws_autoscaling_group" "web_ec2_asg" {
  name                 = "web-ec2-asg"
  min_size             = 4
  max_size             = 4
  desired_capacity     = 4
  launch_configuration = aws_launch_configuration.web_ec2_launch_config.name
  vpc_zone_identifier  = [aws_subnet.ec2_private_subnet_1a.id, aws_subnet.ec2_private_subnet_1d.id, aws_subnet.ec2_private_subnet_1c.id]
  }



# ---------------------------
# 管理サーバ Auto Scaling
# ---------------------------
resource "aws_key_pair" "manage_ec2_key" {
  key_name   = "manage_ec2_access_key"
  public_key = file("./ec2_keys/manage_ec2_access_key.pub")
}

resource "aws_launch_configuration" "manage_ec2_launch_config" {
  name          = "manage_ec2_launch_config"
  image_id      = "ami-0773f473abe438849"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.manage_ec2_key.key_name
  user_data = file("./params/initialize.sh")
  }

resource "aws_autoscaling_group" "manage_ec2_asg" {
  name                 = "manage-ec2-asg"
  min_size             = 1
  max_size             = 1
  desired_capacity     = 1
  launch_configuration = aws_launch_configuration.web_ec2_launch_config.name
  vpc_zone_identifier  = [aws_subnet.ec2_private_subnet_1a.id]
  }
