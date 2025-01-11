targetScope = 'resourceGroup'

param location string = 'uksouth'

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: 'logws'
  location: location
  properties: {
    sku: {
      name: 'Free'
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
