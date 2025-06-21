@description('The name of the Log Analytics workspace')
param workspaceName string

@description('The location for the Log Analytics workspace')
param location string

@description('Tags to apply to the resource')
param tags object

@description('The SKU of the Log Analytics workspace')
@allowed(['Free', 'Standard', 'Premium', 'PerNode', 'PerGB2018', 'Standalone'])
param sku string = 'PerGB2018'

@description('The retention period in days')
@minValue(30)
@maxValue(730)
param retentionInDays int = 30

// Log Analytics Workspace
resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: workspaceName
  location: location
  tags: tags
  properties: {
    sku: {
      name: sku
    }
    retentionInDays: retentionInDays
    features: {
      searchVersion: 1
    }
  }
}

// Outputs
@description('The resource ID of the Log Analytics workspace')
output workspaceId string = logAnalyticsWorkspace.id

@description('The customer ID of the Log Analytics workspace')
output customerId string = logAnalyticsWorkspace.properties.customerId

@description('The name of the Log Analytics workspace')
output workspaceName string = logAnalyticsWorkspace.name
