include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  shared = read_terragrunt_config(find_in_parent_folders("shared.hcl"))
}

terraform {
  source = "../../../modules/ecs-task-scheduler"
  # Or pin from git:
  # source = "git::https://github.com/priyabratas-netizen/terraform-modules.git//modules/ecs-task-scheduler?ref=main"
}

inputs = {
  # --- Required / core ---
  
  
  
  
  name                = "log-anomaly-dev"

  vpc_id              = local.shared.locals.vpc_id
  private_subnet_ids  = local.shared.locals.private_subnet_ids
  public_subnet_ids   = local.shared.locals.public_subnet_ids
  task_subnet_ids     = local.shared.locals.task_subnet_ids

  # Optional: let module create task SGs (empty list) or supply your own IDs
  task_security_group_ids = local.shared.locals.task_security_group_ids

  # Container
  container_image     = "985504043303.dkr.ecr.us-east-1.amazonaws.com/oho/log-anomaly:latest"
  container_name      = "scheduled-container"            # default, override if you want
  container_port      = 8080                             # default, change if your app needs

  # Fargate sizing (module vars are fargate_cpu/memory)
  fargate_cpu         = 512
  fargate_memory      = 1024

  # Task networking
  task_assign_public_ip = true   # you’re using a public subnet; set false if moving to private+NAT

  # Schedule
  schedule_expression = "rate(5 minutes)"

  # EC2 helper instance
  ec2_instance_type      = "t3.micro"
  ec2_ami_id             = "ami-0360c520857e3138f"   # must exist in region
  ec2_allocate_public_ip = true
  ec2_subnet_id          = local.shared.locals.ec2_subnet_id
  create_ec2_instance_profile = true

  # IMPORTANT: module expects "ondemand" or "spot"
  ec2_purchase_option    = "ondemand"

  # Tags
  tags = merge(
    local.shared.locals.common_tags,
    {
      Environment = "poc"
      Owner       = "kalana"
      Name        = "oho-log-anomaly"
      app         = "log-anomaly"
    }
  )
}

