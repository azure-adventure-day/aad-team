resource "random_string" "azuresqldbpw" {
  length = 16
  special = false
  min_upper = "2"
  min_lower = "2"
  min_numeric = "2"
}