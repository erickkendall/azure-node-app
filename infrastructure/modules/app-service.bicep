@description('The name of the App Service')
param appServiceName string

@description('The location for the App Service')
param location string

@description('The resource ID of the App Service Plan')
param appServicePlanId string

@description('The Node.js version to use')
param nodeVersion string

@description('Application Insights instrumentation key')
param applicationInsightsInstrumentationKey string

@description('Application Insights connection string')
param applicationInsightsConnectionString string

@description('The environment name')
param environment string

@description('Tags to apply to the resource')
param tags object

// App Service
resource appService 'Microsoft.Web/sites@2023-01-01' = {
  name: appServiceName
  location: location
  tags: tags
  kind: 'app,linux'
  properties: {
    serverFarmId: appServicePlanId
    httpsOnly: true
    clientAffinityEnabled: false
    siteConfig: {
      linuxFxVersion: 'NODE|${nodeVersion}'
      alwaysOn: environment == 'prod' ? true : false
      ftpsState: 'Disabled'
      minTlsVersion: '1.2'
      scmMinTlsVersion: '1.2'
      http20Enabled: true
      appSettings: [
        {
          name: 'WEBSITE_NODE_DEFAULT_VERSION'
          value: nodeVersion
        }
        {
          name: 'NODE_ENV'
          value: environment == 'prod' ? 'production' : 'development'
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: applicationInsightsInstrumentationKey
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: applicationInsightsConnectionString
        }
        {
          name: 'WEBSITE_HEALTHCHECK_MAXPINGFAILURES'
          value: '10'
        }
        {
          name: 'SCM_DO_BUILD_DURING_DEPLOYMENT'
          value: 'true'
        }
      ]
      healthCheckPath: '/health'
    }
  }
}

// Outputs
@description('The URL of the App Service')
output appServiceUrl string = 'https://${appService.properties.defaultHostName}'

@description('The name of the App Service')
output appServiceName string = appService.name

@description('The resource ID of the App Service')
output appServiceId string = appService.id
