resource "aws_db_parameter_group" "para_prod" {
    name = "para_prod"
    family = "mysql5.7"
    description = "Managed by Terraform"

    parameter {
      name = "time_zone"
      value = "Asia/Tokyo"
    }
}
