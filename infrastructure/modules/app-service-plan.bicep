@description('The name of the App Service Plan')
param appServicePlanName string

@description('The location for the App Service Plan')
param location string

@description('The SKU for the App Service Plan')
param sku object

@description('Tags to apply to the resource')
param tags object

// App Service Plan
resource appServicePlan 'Microsoft.Web/serverfarms@2023-01-01' = {
  name: appServicePlanName
  location: location
  tags: tags
  sku: {
    name: sku.name
    tier: sku.tier
    capacity: sku.capacity
  }
  kind: 'linux'
  properties: {
    reserved: true // Required for Linux plans
  }
}

// Outputs
@description('The resource ID of the App Service Plan')
output appServicePlanId string = appServicePlan.id

@description('The name of the App Service Plan')
output appServicePlanName string = appServicePlan.name
