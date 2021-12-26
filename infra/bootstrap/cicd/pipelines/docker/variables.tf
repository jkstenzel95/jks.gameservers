variable "region" {
    description = "aws region"
    default = "us-east-2"
}

variable "repository_branch" {
    description = "repository branch to connect to"
    default = "main"
}

variable "repository_owner" {
    description = "github repository owner"
    default = "jkstenzel95"
}

variable "repository_name" {
    description = "github repository name"
    default = "jks.gameservers"
}

variable "github_connection_arn" {
    description = "the arn of the github connection"
    default = "arn:aws:codestar-connections:us-east-2:493757919697:connection/f7703010-9ff0-4aed-875d-babb63ce26bf"
}