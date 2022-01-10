module docker_pipeline {
    source = "./docker"

    role_arn = var.role_arn    
}

module eks_pipeline {
    source = "./eks"

    role_arn = var.role_arn    
}

module shared_packages_pipeline {
    source = "./shared-packages"

    role_arn = var.role_arn    
}