# Create the App Service Plan module
cat > infrastructure/modules/app-service-plan.bicep << 'EOF'
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
EOF

# Create the App Service module
cat > infrastructure/modules/app-service.bicep << 'EOF'
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
EOF

# Create the Log Analytics module
cat > infrastructure/modules/log-analytics.bicep << 'EOF'
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
EOF

# Create the Application Insights module
cat > infrastructure/modules/application-insights.bicep << 'EOF'
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
EOF

# Create the development parameters file
cat > infrastructure/parameters/dev.bicepparam << 'EOF'
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
EOF

# Create the production parameters file
cat > infrastructure/parameters/prod.bicepparam << 'EOF'
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
EOF

echo "✅ Bicep infrastructure files created successfully!"
