resource "azurerm_sql_server" "gamesqlserver" {
  name                         = "gamesqlserver${random_string.random.result}"
  resource_group_name          = azurerm_resource_group.aksrg.name
  location                     = azurerm_resource_group.aksrg.location
  version                      = "12.0"
  administrator_login          = "gamedbadministrator"
  administrator_login_password = "${random_string.azuresqldbpw.result}"


}

resource "azurerm_sql_database" "gamedb" {
  name                             = "gamedb"
  resource_group_name              = azurerm_resource_group.aksrg.name
  location                         = azurerm_resource_group.aksrg.location
  server_name                      = "${azurerm_sql_server.gamesqlserver.name}"
  edition                          = "GeneralPurpose"
  requested_service_objective_name = "GP_Gen5_8"
}
