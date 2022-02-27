output base_sg_id {
    description = "id of the base security group"
    value = module.base_sg.sg_id
}

output node_sg_id {
    description = "id of the node security group"
    value = module.node_sg.sg_id
}

output ark_sg_id {
    description = "id of the ark security group"
    value = module.ark_sg.sg_id
}

output minecraft_sg_id {
    description = "id of the minecraft security group"
    value = module.minecraft_sg.sg_id
}