# Creating EFS file system
resource "aws_efs_file_system" "efs" {
  creation_token   = "my-efs"
  encrypted        = true
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  # lifecycle_policy {
  #   transition_to_primary_storage_class = "AFTER_1_ACCESS"
  #   transition_to_ia = "AFTER_30_DAYS"
    
  # }

    lifecycle_policy {
      transition_to_ia = "AFTER_30_DAYS" 
        }
    lifecycle_policy {
      transition_to_primary_storage_class = "AFTER_1_ACCESS" 
        }

  tags = {
    Name = "MyProduct"
  }
}
# Creating Mount target of EFS
resource "aws_efs_mount_target" "mount" {
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = module.vpc.public_subnets[0]
  security_groups = [aws_security_group.ec2_security_group.id]
}
# Creating Mount Point for EFS
resource "null_resource" "configure_nfs" {
  depends_on = [aws_efs_mount_target.mount]
  connection {
    type = "ssh"
    user = "ec2-user"
    #private_key = "dolibarr"
    private_key = tls_private_key.my_key.private_key_pem #?????
    host        = module.ec2_instance.public_subnets     #?????
  }
}

#policy backup
resource "aws_efs_backup_policy" "efs" {
  file_system_id = aws_efs_file_system.efs.id

  backup_policy {
    status = "ENABLED"
  }
}

# lifecycle
# resource "aws_lifecycle" "transition" {

#   file_system_id = aws_efs_file_system.efs.id
# lifecycle_policy {
#   transition_to_ia = "AFTER_30_DAYS"
#  }
#}


# resource "aws_efs_file_system" "efs_with_lifecyle_policy" {
#   creation_token = "my-product"

#   lifecycle_policy {
#     transition_to_ia = "AFTER_30_DAYS"
#   }
# }




# module "efs" {
#   source = "terraform-aws-modules/efs/aws"

# File system
#name           = "efstf"
#creation_token = "efstf"
#encrypted      = true
#kms_key_arn    = "arn:aws:kms:eu-west-1:111122223333:key/1234abcd-12ab-34cd-56ef-1234567890ab"

# performance_mode = "generalPurpose"
# throughput_mode  = "bursting"
#provisioned_throughput_in_mibps = 256

# lifecycle_policy = {
#  transition_to_ia = "AFTER_30_DAYS"
# }

# File system policy
#   attach_policy                      = true
#   bypass_policy_lockout_safety_check = false
#   policy_statements = [
#     {
#       sid     = "Example"
#       actions = ["elasticfilesystem:ClientMount"]
#       principals = [
#         {
#           type        = "AWS"
#           identifiers = ["arn:aws:iam::111122223333:role/EfsReadOnly"]
#         }
#       ]
#     }
#   ]

# Mount targets / security group
# mount_targets = {
#   "us-east-1a" = {
#     subnet_id = module.vpc.public_subnets[0]
#     security_group_rules = aws_security_group.sg_efs.id
#   }
# "eu-west-1b" = {
#   subnet_id = "subnet-bcde012a"
# }
# "eu-west-1c" = {
#   subnet_id = "subnet-fghi345a"
# }
# }
# security_group_description = "Example EFS security group"
# security_group_vpc_id      = "vpc-1234556abcdef"
# security_group_rules = {
#   vpc = {
#     # relying on the defaults provdied for EFS/NFS (2049/TCP + ingress)
#     description = "NFS ingress from VPC private subnets"

#     cidr_blocks = "10.0.0.0/16"
#   }
# }

# Access point(s)
#   access_points = {
#     posix_example = {
#       name = "posix-example"
#       posix_user = {
#         gid            = 1001
#         uid            = 1001
#         secondary_gids = [1002]
#       }

#       tags = {
#         Additionl = "yes"
#       }
# }
# root_example = {
#   root_directory = {
#     path = "/var/www/html/teampass/"
#     creation_info = {
#       owner_gid   = 1001
#       owner_uid   = 1001
#       permissions = "755"
#     }
#   }
# }
#}

# Backup policy
#enable_backup_policy = true

# Replication configuration
#   create_replication_configuration = true
#   replication_configuration_destination = {
#     region = "us-east-1"
#   }

#   tags = {
#     Terraform   = "true"
#     Environment = "dev"
#   }
#}