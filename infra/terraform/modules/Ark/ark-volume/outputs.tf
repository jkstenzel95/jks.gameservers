output "id" {
    description = "the id of the volume created that is to be shared by multiple Ark servers"
    value = module.volume.id
}