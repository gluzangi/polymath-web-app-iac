# Manage AWS Resources

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.21.0"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.vpc_azs
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets

  enable_nat_gateway = var.vpc_enable_nat_gateway

  tags = var.vpc_tags
}

module "ec2_instances" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.12.0"

  name           = "nomadbox"
  instance_count = 1

  ami            = "ami-0892d3c7ee96c0bf7"
  instance_type  = "t3.micro"
  key_name               = module.key_pair.key_pair_key_name
  vpc_security_group_ids = [module.security_group.security_group_id]
  subnet_id              = module.vpc.public_subnets[0]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "security_group" {
    source  = "terraform-aws-modules/security-group/aws"
    version = "4.7.0"

    name    = "ssh-server-sg"
    description = "Security Group For Public Subnet"

    vpc_id  = module.vpc.vpc_id
    ingress_cidr_blocks = ["0.0.0.0/0"]

    ingress_rules = ["ssh-tcp", "nomad-http-tcp", "nomad-rpc-tcp", "nomad-serf-tcp", "nomad-serf-udp", "postgresql-tcp", "http-8080-tcp", "all-icmp"]
    egress_rules = ["all-all"]

    tags = {
      Terraform   = "true"
      Environment = "dev"
    }
}


module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"
  version = "1.0.0"

  key_name   = "deployer-key"
  public_key = file("/home/gluzangi/.ssh/id_rsa.pub")
}
