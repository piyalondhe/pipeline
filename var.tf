variable "aws_region" {
  description = "AWS region"
  default     = "eu-central-1"
  type        = string
}


variable "instance_count" {
  default = "2"
}


variable "ssh_user_name" {
    default = "ec2-user"
}
variable "ssh_key_name" {
    default = "ssh-connect"
}
variable "ssh_key_path" {
    default = "/home/ec2-user/terraform_ansible_integration/ssh-connect.pem"
}


variable "dev_host_label" {
    default = "all"
}


variable "instance_name" {
    default = "terra-ansible"
}
