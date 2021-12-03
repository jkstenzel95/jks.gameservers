output "instances" {
    description = "the instances created"
    value = module.instances[*].instance
}