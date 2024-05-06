# resource "aws_instance" "elbinstance" {
#     ami = var.ami
#     subnet_id = aws_subnet.Demo2.id
#     associate_public_ip_address="true"
#     instance_type="t2.micro"
#     count =1
#     user_data = <<-EOF
#               #!/bin/bash
#               yum update -y
#               yum install -y httpd
#               systemctl start httpd
#               systemctl enable httpd
#               sudo echo "<center><h3>Hi from $(hostname -f)</h3></center>" > /var/www/html/index.html
#               EOF
#     vpc_security_group_ids = [aws_security_group.web_app.id]
#     key_name="mykeyp"
#     tags={
#         Name= "Instance-${count.index + 1}"
#     }
  
# }

