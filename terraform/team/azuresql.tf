resource "azurerm_sql_server" "gamesqlserver" {
  name                         = "gamesqlserver${random_string.random.result}"
  resource_group_name          = azurerm_resource_group.aksrg.name
  location                     = azurerm_resource_group.aksrg.location
  version                      = "12.0"
  administrator_login          = "gamedbadministrator"
  administrator_login_password = "${random_string.azuresqldbpw.result}"


}

resource "azurerm_mssql_database" "gamedb" {
  name           = "gamedb"
  server_id      = azurerm_sql_server.gamesqlserver.id
  max_size_gb    = 32
  sku_name       = "GP_Gen5_8"
}