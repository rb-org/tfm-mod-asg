/*
 * Module: tf_aws_asg_elb
 *
 * This template creates the following resources
 *   - A launch configuration
 *   - A auto-scaling group
 *
 * It requires you create an ELB instance before you use it.
 */

resource "aws_launch_configuration" "main_lc" {
  #name_prefix = "${var.name}-lc-"
  name                 = "${var.name}-lc-${var.app_version}"
  image_id             = "${var.ami_id}"
  instance_type        = "${var.instance_type}"
  iam_instance_profile = "${var.iam_instance_profile}"
  key_name             = "${var.key_name}"
  security_groups      = ["${var.security_group}"]
  user_data            = "${data.template_file.bootstrap.rendered}"

  #user_data =           "${file(var.user_data)}"
  lifecycle {
    ignore_changes        = ["user_data"]
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "main_asg" {
  vpc_zone_identifier = ["${var.vpc_zone_identifier}"]

  #name                      = "${var.name}"
  name                      = "${aws_launch_configuration.main_lc.name}-asg"
  max_size                  = "${var.asg_max_size}"
  min_size                  = "${var.asg_min_size}"
  desired_capacity          = "${var.desired_capacity}"
  health_check_grace_period = "${var.health_check_grace_period}"
  health_check_type         = "${var.health_check_type}"
  default_cooldown          = "${var.default_cooldown}"
  desired_capacity          = "${var.desired_capacity}"
  force_delete              = true

  #placement_group           = "${aws_placement_group.test.id}"
  launch_configuration = "${aws_launch_configuration.main_lc.name}"

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances",
  ]

  lifecycle {
    create_before_destroy = true
  }

  tags = [
    {
      key                 = "Name"
      value               = "${var.name}"
      propagate_at_launch = true
    },
    {
      key                 = "Terraform"
      value               = "true"
      propagate_at_launch = true
    },
    {
      key                 = "Environment"
      value               = "${terraform.workspace}"
      propagate_at_launch = true
    },
    {
      key                 = "AppVersion"
      value               = "${var.app_version}"
      propagate_at_launch = true
    },
    {
      key                 = "AppRole"
      value               = "${var.app_role}"
      propagate_at_launch = true
    },
    {
      key                 = "AppId"
      value               = "${var.app_id}"
      propagate_at_launch = true
    },
    {
      key                 = "AMI_Id"
      value               = "${var.ami_id}"
      propagate_at_launch = true
    },
    {
      key                 = "Backup"
      value               = "false"
      propagate_at_launch = true
    },
    {
      key                 = "ChefEnabled"
      value               = "false"
      propagate_at_launch = true
    },
    {
      key                 = "SvrType"
      value               = "${var.svr_type}"
      propagate_at_launch = true
    },
    {
      key                 = "policy:offhours"
      value               = "${var.offhours}"
      propagate_at_launch = true
    },
  ]
}

resource "aws_autoscaling_attachment" "asg_attachment_main" {
  autoscaling_group_name = "${aws_autoscaling_group.main_asg.id}"
  alb_target_group_arn   = "${var.alb_target_group_arn}"
}

data "template_file" "bootstrap" {
  template = "${file(var.user_data)}"

  vars {
    newName = "${upper(terraform.workspace)}${upper(var.app_id)}"
  }
}
