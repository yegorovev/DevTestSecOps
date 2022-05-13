resource "aws_launch_configuration" "launch" {
  name                 = var.launch_config.name
  image_id             = var.launch_config.image_id
  instance_type        = var.launch_config.instance_type
  key_name             = var.launch_config.key_name
  security_groups      = var.launch_config.security_groups
  iam_instance_profile = var.launch_config.iam_instance_profile
  user_data            = var.launch_config.user_data
}

resource "aws_autoscaling_group" "autoscaling_group" {
  name                 = var.asg_config.name
  min_size             = var.asg_config.min_size
  max_size             = var.asg_config.max_size
  desired_capacity     = var.asg_config.desired_capacity
  launch_configuration = aws_launch_configuration.launch.name
  vpc_zone_identifier  = var.asg_config.vpc_zone_identifier
}
