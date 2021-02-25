resource "random_string" "azuresqldbpw" {
  length = 14
  special = true
  upper = true
}
