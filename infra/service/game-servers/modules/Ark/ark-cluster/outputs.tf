output "scale_groups" {
    description = "the scale groups created"
    value = module.scale_groups[*].scale_group
}