module map_resources {
    source = "./valheim-resources"
    count = length(var.maps)

    server_region = "${var.server_region}"
    region_shortname = "${var.region_shortname}"
    map_name = element(var.maps, count.index)
    env = "${var.env}"
    availability_zone = "${var.availability_zone}"
    packages_bucket_arn = "${var.packages_bucket_arn}"
}