targetScope = 'resourceGroup'

param location string = 'uksouth'

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: 'logws'
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 7
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
    workspaceCapping: {
      dailyQuotaGb: 1
    }
  }
}

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: 'appins'
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalyticsWorkspace.id
  }
}

module dashboard './dashboard.json' = {
  name: 'dashboard'
  params: {
    location: location
    logAnalyticsWorkspaceId: logAnalyticsWorkspace.id
  }
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: uniqueString('storage', resourceGroup().id)
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}

resource servicePlan 'Microsoft.Web/serverfarms@2024-04-01' = {
  name: 'serviceplan'
  location: location
  kind: 'functionapp,linux'
  sku: {
    name: 'F1'
  }
  properties: {
    reserved: true
  }
}
