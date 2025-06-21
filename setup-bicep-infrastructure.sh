#!/bin/bash

# Bicep Infrastructure Setup Script
# Run this script to create the Bicep infrastructure files

set -e

echo "🏗️  Setting up Bicep Infrastructure as Code..."

# Create infrastructure directory structure
echo "📁 Creating infrastructure directories..."
mkdir -p infrastructure/modules
mkdir -p infrastructure/parameters

echo "✅ Infrastructure directories created!"

# Create main.bicep
echo "📄 Creating main.bicep..."
cat > infrastructure/main.bicep << 'EOF'
@description('The name of the web app')
param appName string

@description('The location for all resources')
param location string = resourceGroup().location

@description('The environment name (dev, staging, prod)')
@allowed(['dev', 'staging', 'prod'])
param environment string = 'dev'

@description('The Node.js version to use')
param nodeVersion string = '18-lts'

@description('Tags to apply to all resources')
param tags object = {
  project: 'azure-node-app'
  environment: environment
  'created-by': 'bicep'
}

// Variables for naming convention
var resourceSuffix = '${appName}-${environment}'
var appServicePlanName = 'plan-${resourceSuffix}'
var appServiceName = 'app-${resourceSuffix}'
var applicationInsightsName = 'appi-${resourceSuffix}'
var logAnalyticsWorkspaceName = 'log-${resourceSuffix}'

// Determine SKU based on environment
var appServicePlanSku = environment == 'prod' ? {
  name: 'P1v3'
  tier: 'PremiumV3'
  capacity: 1
} : {
  name: 'B1'
  tier: 'Basic'
  capacity: 1
}

// Log Analytics Workspace for Application Insights
module logAnalytics 'modules/log-analytics.bicep' = {
  name: 'logAnalyticsDeployment'
  params: {
    workspaceName: logAnalyticsWorkspaceName
    location: location
    tags: tags
  }
}

// Application Insights
module applicationInsights 'modules/application-insights.bicep' = {
  name: 'applicationInsightsDeployment'
  params: {
    applicationInsightsName: applicationInsightsName
    location: location
    tags: tags
    logAnalyticsWorkspaceId: logAnalytics.outputs.workspaceId
  }
}

// App Service Plan
module appServicePlan 'modules/app-service-plan.bicep' = {
  name: 'appServicePlanDeployment'
  params: {
    appServicePlanName: appServicePlanName
    location: location
    sku: appServicePlanSku
    tags: tags
  }
}

// App Service
module appService 'modules/app-service.bicep' = {
  name: 'appServiceDeployment'
  params: {
    appServiceName: appServiceName
    location: location
    appServicePlanId: appServicePlan.outputs.appServicePlanId
    nodeVersion: nodeVersion
    applicationInsightsInstrumentationKey: applicationInsights.outputs.instrumentationKey
    applicationInsightsConnectionString: applicationInsights.outputs.connectionString
    environment: environment
    tags: tags
  }
}

// Outputs
@description('The URL of the deployed web app')
output appServiceUrl string = appService.outputs.appServiceUrl

@description('The name of the App Service')
output appServiceName string = appService.outputs.appServiceName

@description('The resource group name')
output resourceGroupName string = resourceGroup().name

@description('The Application Insights instrumentation key')
output applicationInsightsInstr
