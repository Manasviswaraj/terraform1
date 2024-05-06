# data "template_file" "rendered_php" {
#   template = file("${path.module}/index.php.tpl")

#   vars = {
#     rds_endpoint = "${var.rds_endpoint}"
#     rds_username = "${var.rds_username}"
#     rds_password = "${var.rds_password}"
#   }
# }

# output "rendered_php_content" {
#   value = data.template_file.rendered_php.rendered
# }