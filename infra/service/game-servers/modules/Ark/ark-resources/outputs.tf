output resources_bucket_arn {
    description = "the arn of the bucket containing additional game resources"
    value =  module.resources_bucket.arn
}

output resources_bucket_name {
    description = "the name of the bucket containing additional game resources"
    value =  module.resources_bucket.name
}

output backup_bucket_name {
    description = "the name of the bucket containing game backups"
    value =  module.backup_bucket.name
}

output backup_bucket_arn {
    description = "the arn of the bucket containing game backups"
    value =  module.backup_bucket.arn
}

output data_access_policy_arn {
    description = "the policy allowing access to data stores"
    value = aws_iam_policy.data_access_policy.arn 
}

output shared_data_volume_id {
    description = "the id of the shared data volume to use"
    value = module.shared_data_volume.id
}