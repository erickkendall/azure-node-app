using '../main.bicep'

param appName = 'azurenodeapp'
param location = 'East US'
param environment = 'dev'
param nodeVersion = '18-lts'
param tags = {
  project: 'azure-node-app'
  environment: 'dev'
  'created-by': 'bicep'
  owner: 'erick-kendall'
  'cost-center': 'development'
}
