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

output "SQL_PASSWORD" {
  value = random_string.azuresqldbpw.result
}

output "SQL_DATABASE_NAME" {
  description = "Database name of the Azure SQL Database created."
  value       = azurerm_sql_database.gamedb.name
}

output "SQL_SERVER_NAME" {
  description = "Server name of the Azure SQL Database created."
  value       = azurerm_sql_server.gamesqlserver.name
}

output "SQL_SERVER_LOCATION" {
  description = "Location of the Azure SQL Database created."
  value       = azurerm_sql_server.gamesqlserver.location
}

output "SQL_SERVER_VERSION" {
  description = "Version the Azure SQL Database created."
  value       = azurerm_sql_server.gamesqlserver.version
}

output "SQL_FQDN" {
  description = "Fully Qualified Domain Name (FQDN) of the Azure SQL Database created."
  value       = azurerm_sql_server.gamesqlserver.fully_qualified_domain_name
}

output "SQL_CONNECTION_STRING" {
  description = "Connection string for the Azure SQL Database created."
  value       = "Server=tcp:${azurerm_sql_server.gamesqlserver.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_sql_database.gamedb.name};Persist Security Info=False;User ID=${azurerm_sql_server.gamesqlserver.administrator_login};Password=${azurerm_sql_server.gamesqlserver.administrator_login_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
}
