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
