output games_sg_id {
    description = "id of the games security group"
    value = module.games_sg.sg_id
}

output node_sg_id {
    description = "id of the node security group"
    value = module.node_sg.sg_id
}