# Output the ID of the Launch Config
output "lc_id" {
  value = "${aws_launch_configuration.main_lc.id}"
}

/*
output "launch_config_grn_id" {
    value = "${aws_launch_configuration.launch_config_green.id}"
}
*/
# Output the ID of the Launch Config
output "asg_id" {
  value = "${aws_autoscaling_group.main_asg.id}"
}
