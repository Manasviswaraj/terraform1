# resource "aws_eip" "nateip"{
#     tags = {name="eip"}
# }
# resource "aws_nat_gateway" "natgw" {
#     allocation_id = aws_eip.nateip.id
#     subnet_id = aws_subnet.Demo2.id
  
# }
# resource "aws_route_table" "natroute" {
#     vpc_id = "vpc-09e1db052e5bd0b68"
#     route {
#         cidr_block = "0.0.0.0/0"
#         gateway_id = aws_nat_gateway.natgw.id
#     }
# }
  
# resource "aws_route_table_association" "nat_assocition" {

#  subnet_id= aws_subnet.Demo2.id
#  route_table_id= aws_route_table.natroute.id 
# }
