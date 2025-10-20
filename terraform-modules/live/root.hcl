# terraform-modules/live/root.hcl
locals {
  aws_region  = "us-east-1"
  aws_profile = "devops-sandbox"
  project     = "insighture"
}

remote_state {
  backend = "s3"
  generate = { path = "backend.tf", if_exists = "overwrite" }
  config = {
    bucket         = "tfstate-${local.project}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.aws_region
    profile        = local.aws_profile
    encrypt        = true
    dynamodb_table = "tf-locks-${local.project}"
  }
}

