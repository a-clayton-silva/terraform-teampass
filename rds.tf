module "rds" {
  source = "aws/rds"

  db_instance_identifier = "mydbinstance"
  allocated_storage      = 20
  engine                 = "postgres"
  engine_version         = "13.1"
  instance_class         = "db.t2.micro"
  name                   = "mydatabase"
  username               = "mydbuser"
  password               = "mysecretpassword"
  vpc_security_group_ids = [aws_security_group.rds.id]
  subnet_ids             = [module.vpc.private_subnet_ids]
}

resource "aws_security_group" "rds" {
  name        = "rds-security-group"
  description = "Security group for RDS instances"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

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
