data "template_file" "buildspec" {
    template = "${templatefile("${path.module}/specs/${var.template_filename}", { env = "${var.env}" })}"
}

module "codebuild" {
  source = "../../../modules/codebuild"

  buildspec = data.template_file.buildspec
  name = "${var.name}"
  build_role_arn = var.build_role_arn
  privileged_mode = var.privileged_mode
}