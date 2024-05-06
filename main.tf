provider "aws" {
  region = "us-east-1"
}

# resource "aws_security_group" "mysg" {
#     name="mysg"
#     vpc_id= "vpc-09e1db052e5bd0b68"

    
#     dynamic "ingress" { 
#         for_each = [22,80,443]
#          iterator=port
#         content {
#          description="tls from VPC"
#          from_port= port.value
#          to_port=port.value
#          protocol = "tcp"
#          cidr_blocks= ["0.0.0.0/0"]
#     }
    
       
      
#     }
  

  
# }

resource "aws_security_group" "web_app" {
  name        = "web_app"
  description = "security group"
  ingress {
    from_port   = 3389  # RDP port
    to_port     = 3389  # RDP port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Adjust to limit the source IP range if needed
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags= {
    Name = "web_app"
  }
}
# resource "null_resource" "example" {
#   provisioner "remote-exec" {
#     inline = [
#       "${var.bash_script}"
#     ]

#     connection {
#       type     = "ssh"
#       user     = "ec2-user"  # Change this to your EC2 instance's username
#       private_key = file("C:\Users\Manasvi\Downloads\mykeyp.pem")  # Change this to the path to your private key
#       host     = aws_instance.elbinstance.public_ip  # Change this to your EC2 instance's public IP
#     }
#   }
# }



resource "aws_instance" "Instance" {
    ami = "ami-04b70fa74e45c3917"
    subnet_id = aws_subnet.puba.id
    associate_public_ip_address="true"
    instance_type="t2.micro"
    count =1
    user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y apache2
              sudo systemctl start apache2
              sudo systemctl enable apache2
              sudo apt-get update 
              sudo apt-get install jq
              sudo apt-get install -y unzip
              sudo wget -qO /tmp/my_script.zip https://lms.intellipaat.com/mediaFiles/2020/10/code.zip
              sudo unzip -o /tmp/my_script.zip -d /var/www/html/
              sudo add-apt-repository -y ppa:ondrej/php
              sudo apt install php5.6 mysql-client php5.6-mysqli -y
              
              sudo mv /var/www/html/1243/* /var/www/html/          
              sudo rm -r /var/www/html/1243/ 
              sudo rm var/www/html/index.html
              # sudo echo "<center><h3>Hi from $(hostname -f)</h3></center>" > /var/www/html/index.html
              EOF
    vpc_security_group_ids = [aws_security_group.web_app.id]
    key_name="mykeyp"
    tags={
        Name= "Instance-${count.index + 1}"
    }
  
}


# resource "aws_instance" "Windows" {
#     ami = "ami-03cd80cfebcbb4481"
#     subnet_id = aws_subnet.Demo2.id
#     associate_public_ip_address="true"
#     instance_type="t2.micro"
#     count =1
#     vpc_security_group_ids = [aws_security_group.web_app.id]
#     key_name="mykeyp"
#     tags={
#         Name= "Instance-${count.index + 1}"
#     }
  
#}
output "instances_info" {
  value = {
    for instance in aws_instance.Instance : instance.id => {
      subnet_id   = instance.subnet_id
      public_ip   = instance.public_ip
      private_ip  = instance.private_ip
    }
  }
}



