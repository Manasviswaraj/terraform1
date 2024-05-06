resource "aws_subnet" "Privb" {
  vpc_id = "vpc-09e1db052e5bd0b68"
  cidr_block = "172.31.0.0/28"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = "false"
  tags = {
    Name = "privb"

  }
}

resource "aws_subnet" "priva" {
  vpc_id = "vpc-09e1db052e5bd0b68"
  cidr_block = "172.31.0.32/28"
  map_public_ip_on_launch = "true"
  availability_zone = "us-east-1a"
  tags = {
    Name = "priva"

  }

}

resource "aws_subnet" "pubb" {
  vpc_id = "vpc-09e1db052e5bd0b68"
  cidr_block = "172.31.0.80/28"
  map_public_ip_on_launch = "true"
  availability_zone = "us-east-1b"
  
  tags = {
    Name = "pubb"

  }

}

resource "aws_subnet" "puba" {
  vpc_id = "vpc-09e1db052e5bd0b68"
  cidr_block = "172.31.0.112/28"
  map_public_ip_on_launch = "true"
  availability_zone = "us-east-1a"
  tags = {
    Name = "puba"

  }

}


resource "aws_internet_gateway" "igw_dev" {
  vpc_id = "vpc-09e1db052e5bd0b68"
  tags = {
    name="ig_dev"
    }
}
 
resource "aws_route_table" "dev-public-1" {
  vpc_id = "vpc-09e1db052e5bd0b68"
   route {
    
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_dev.id
   }
   tags ={
    name ="dev"}
 }

resource "aws_route_table" "dev-private-1" {
  vpc_id = "vpc-09e1db052e5bd0b68"
  route{
    cidr_block = "172.31.0.0/16"
    gateway_id = "local"
 }
}

resource "aws_route_table_association" "dev-private-1a" {
  subnet_id= aws_subnet.priva.id
  route_table_id=aws_route_table.dev-private-1.id
  
}

resource "aws_route_table_association" "dev-public-2a" {
  subnet_id= aws_subnet.puba.id
  route_table_id=aws_route_table.dev-public-1.id
  
}

resource "aws_route_table_association" "dev-public-2b" {
  subnet_id=aws_subnet.pubb.id
  route_table_id= aws_route_table.dev-public-1.id
}

resource "aws_route_table_association" "dev-private-1b" {
  subnet_id= aws_subnet.Privb.id
  route_table_id=aws_route_table.dev-private-1.id
}

resource "aws_db_subnet_group" "mysubnetgroup" {
  name= "mydbsubnetgroup"
  subnet_ids = [
    aws_subnet.pubb.id , aws_subnet.puba.id
  ]
  
}

variable "db_security_group_name" {
  description = "Name of the security group for the RDS DB instance"
  type        = string
  default     = "my-db-security-group"
}

resource "aws_security_group" "my_db_security_group" {
  name        = var.db_security_group_name
  description = "Security group for my RDS DB instance"
  vpc_id      = "vpc-09e1db052e5bd0b68"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow MySQL traffic from anywhere (consider security implications)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow all outbound traffic (consider security implications)
  }
}

resource "aws_db_instance" "my_rds_instance" {
  #name = "my_rds_instance"
  allocated_storage  =  10  # 20 GB storage allocated (Free Tier eligible)
  engine = "mysql"
  engine_version = "8.0.35"  # MySQL 8.0 engine version
  instance_class = "db.t3.micro"  # Free Tier eligible instance type
  storage_type = "gp2"
  port = 3306
  db_name   = "mydb"
  username  = "admin"
  password  = "mypassword"  # Update with your desired password
  db_subnet_group_name = aws_db_subnet_group.mysubnetgroup.name
  vpc_security_group_ids = [aws_security_group.my_db_security_group.id]
  publicly_accessible  = false  # Set to true if you want the instance to be publicly accessible
  skip_final_snapshot  = true  # Set to true to skip taking a final snapshot when deleting the instance
 # initial_db_name  = "initialdb"  # Specify the initial database name here
  #db_parameter_group_name = "default.mysql8.0"  # Default DB parameter group for MySQL 8.0

  
  tags = {
    Name = "My RDS Instance"
  }
  
}

# output "rds_endpoint1" {
#   value = "${aws_db_instance.my_rds_instance.endpoint}"
# }
# output "rds_endpoint2" {
#   value = {
#     #database_subnetname = data.aws_db_instance.db_subnet_group_name
#     database_endpoint = aws_db_instance.my_rds_instance.endpoint

    
#   }
# }
# output "RDS_HOSTNAME" {
#   value = data.aws_db_instance.my_rds_instance.endpoint
# }

# output "RDS_USERNAME" {
#   value = data.aws_db_instance.my_rds_instance.username
# }

# output "RDS_PASSWORD" {
#   value = aws_db_instance.my_rds_instance.password
# }

output "RDS_DB_NAME" {
  value = aws_db_instance.my_rds_instance.db_name
}

# data "template_file" "rendered_php" {
#   template = file("${path.module}/index.php.tpl")

#   vars = {
#     rds_endpoint = "${RDS_HOSTNAME}"
#     rds_username = "${}"
#     rds_password = "${var.rds_password}"
#   }
# }

# output "rendered_php_content" {
#   value = data.template_file.rendered_php.rendered
# }

