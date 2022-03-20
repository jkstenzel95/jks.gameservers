output data_access_policy_arns {
    description = "the policies allowing access to data stores"
    value = module.map_resources[*].data_access_policy_arn
}

output shared_data_volume_ids {
    description = "the id of the shared data volume to use"
    value = module.map_resources[*].shared_data_volume_id
}

output maps {
    description = "the id of the shared data volume to use"
    value = var.maps
}

output resources_bucket_arns {
    description = "the arns of the buckets containing additional game resources"
    value = module.map_resources[*].resources_bucket_arn
}

output resources_bucket_names {
    description = "the names of the buckets containing additional game resources"
    value = module.map_resources[*].resources_bucket_name
}

output backup_bucket_arns {
    description = "the arns of the buckets containing game backups"
    value = module.map_resources[*].backup_bucket_arn
}

output backup_bucket_names {
    description = "the names of the buckets containing game backups"
    value = module.map_resources[*].backup_bucket_name
}