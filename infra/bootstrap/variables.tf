variable "region" {
    description = "aws region"
    default = "us-east-2"
}

variable "ssh_security_group_name" {
    description = "the pre-existing security group providing personal machine ssh access"
    default = "jks-ssh-group"
}

variable "cluster_name" {
    description = "the chosen name for the cluster"
    default = "jks-use2"
}

variable "account_id" {
    description = "the id of the account used"
    default = "493757919697"
}