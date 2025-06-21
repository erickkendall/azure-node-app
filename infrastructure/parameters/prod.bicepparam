using '../main.bicep'

param appName = 'azurenodeapp'
param location = 'East US'
param environment = 'prod'
param nodeVersion = '18-lts'
param tags = {
  project: 'azure-node-app'
  environment: 'prod'
  'created-by': 'bicep'
  owner: 'erick-kendall'
  'cost-center': 'production'
  backup: 'enabled'
  monitoring: 'enabled'
}
