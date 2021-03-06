locals {
  test_clause = var.is_test ? "-t" : ""
}

data "template_file" "buildspec" {
    template = "${templatefile("${path.module}/specs/${var.template_filename}", { region = "${var.region_shortname}", env = "${var.env}", test_clause = "${local.test_clause}", build_role = "${var.build_role_arn}" })}"
}

module "codebuild" {
  source = "../../../modules/codebuild"

  buildspec = data.template_file.buildspec
  name = "${var.name}"
  build_role_arn = var.build_role_arn
}