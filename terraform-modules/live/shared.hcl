locals {
  # — Network (real IDs from your main.tf) —
  vpc_id             = "vpc-0fefffbcfd060bc68"

  private_subnet_ids = ["subnet-08851d6818d40a7de", "subnet-0d03e804190848a65"]
  public_subnet_ids  = ["subnet-0a695afe41b742aa6"]

  # Where the Fargate task runs; you pointed to a public subnet
  task_subnet_ids    = ["subnet-0a695afe41b742aa6"]

  # EC2 helper instance needs a single subnet (use a public one since allocate_public_ip=true)
  ec2_subnet_id      = "subnet-0a695afe41b742aa6"

  # Let the module create a task SG by default. If you already have one, set it here.
  task_security_group_ids = []

  common_tags = {
    project      = "oho"
    organization = "oho"
  }
}

