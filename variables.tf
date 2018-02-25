variable "name" {}

/*
variable "tags" {
  description = "A map of tags to add to all resources"
  default     = { }
}
*/
#variable "svr_name_prefix" {}
#variable "environment" {}
#variable "svr_type" {}
#variable "aws_region" {}
/*
 * Module: tf_aws_asg_elb
 */

#
# Launch Configuration Variables
#
#variable "lc_name" {}
variable "ami_id" {
  description = "The AMI to use with the launch configuration"
}

variable "instance_type" {}

variable "iam_instance_profile" {
  description = "The IAM role the launched instance will use"
}

variable "key_name" {
  description = "The SSH public key name (in EC2 key-pairs) to be injected into instances"
}

variable "security_group" {
  description = "ID of SG the launched instance will use"
  type        = "list"
}

variable "user_data" {
  description = "The path to a file with user_data for the instances"
  default     = ""
}

// Autoscale group variables

variable "asg_max_size" {}

variable "asg_min_size" {
  default = 0
}

variable "desired_capacity" {}
variable "health_check_grace_period" {}
variable "health_check_type" {}

variable "target_group_arns" {
  default = []
}

variable "vpc_zone_identifier" {
  default = []
}

/*
variable "availability_zones" {
  default = []
}
*/
variable "default_cooldown" {
  default = ""
}

variable "alb_target_group_arn" {
  default = ""
}

variable "app_role" {
  default = ""
}

variable "app_id" {
  default = ""
}

variable "app_version" {
  default = "0.0.0"
}

variable "chef_enabled" {
  default = "true"
}

variable "backup_enabled" {
  default = "true"
}

variable "svr_type" {
  default = "exol"
}

variable "offhours" {
  default = "on"
}
