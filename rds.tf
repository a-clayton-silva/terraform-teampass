module "rds" {
  source = "terraform-aws-modules/rds/aws"

  identifier            = "mydbinstance"
  storage_type          = "gp2"
  allocated_storage     = 20
  max_allocated_storage = 100
  engine                = "mysql"
  engine_version        = "8.0"
  major_engine_version  = "8.0"
  instance_class        = "db.t3.micro"
  db_name               = "mydatabase"
  username              = "mydbuser"
  password              = "mysecretpassword"
  port                  = "3306"
  skip_final_snapshot   = true
  deletion_protection   = false
  #  vpc_security_group_ids  = [aws_security_group.rds.id]
  vpc_security_group_ids  = [aws_security_group.ec2_security_group.id]
  subnet_ids              = module.vpc.private_subnets
  backup_retention_period = 7
  family                  = "mysql8.0"
  maintenance_window      = "Mon:00:00-Mon:03:00"
  backup_window           = "03:00-06:00"

  tags = {
    Owner       = "user"
    Environment = "dev"
  }
}

# resource "aws_security_group" "rds" {
#   name        = "rds-security-group"
#   description = "Security group for RDS instances"

# ingress {
#   from_port   = 5432
#   to_port     = 5432
#   protocol    = "tcp"
#   cidr_blocks = ["0.0.0.0/0"]
# }

# ingress {
#   from_port   = 3306
#   to_port     = 3306
#   protocol    = "tcp"
#   cidr_blocks = ["0.0.0.0/0"]
# }

# }

# module "vpc" {
#   source = "terraform-aws-modules/vpc/aws"

#   name = "my-vpc"

#   cidr = "10.0.0.0/16"

#   private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
#   public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

#   tags = {
#     Terraform   = "true"
#     Environment = "dev"
#   }
# }
