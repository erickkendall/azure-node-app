@description('The name of the Application Insights component')
param applicationInsightsName string

@description('The location for the Application Insights component')
param location string

@description('Tags to apply to the resource')
param tags object

@description('The resource ID of the Log Analytics workspace')
param logAnalyticsWorkspaceId string

@description('The kind of Application Insights component')
param kind string = 'web'

@description('The application type')
@allowed(['web', 'other'])
param applicationType string = 'web'

// Application Insights
resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: applicationInsightsName
  location: location
  tags: tags
  kind: kind
  properties: {
    Application_Type: applicationType
    WorkspaceResourceId: logAnalyticsWorkspaceId
    IngestionMode: 'LogAnalytics'
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}

// Outputs
@description('The instrumentation key of the Application Insights component')
output instrumentationKey string = applicationInsights.properties.InstrumentationKey

@description('The connection string of the Application Insights component')
output connectionString string = applicationInsights.properties.ConnectionString

@description('The resource ID of the Application Insights component')
output applicationInsightsId string = applicationInsights.id
