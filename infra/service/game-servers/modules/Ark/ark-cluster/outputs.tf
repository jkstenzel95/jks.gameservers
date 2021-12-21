output "ark_instances" {
    description = "the instances created"
    value = module.ark_instances[*].instance
}