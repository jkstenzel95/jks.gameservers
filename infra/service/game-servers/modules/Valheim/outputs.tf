output data_access_policy_arns {
    description = "the policies allowing access to data stores"
    value = module.map_resources[*].data_access_policy_arn
}