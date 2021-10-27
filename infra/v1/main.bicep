param location string = resourceGroup().location
param skuCode string = 'F1'
param sku string = 'Free'
param version string = 'v1'

resource appsServicePlan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: 'websiteplan-${version}'
  location: location
  sku: {
    tier: sku
    name: skuCode 
  }
}

resource appService 'Microsoft.Web/sites@2021-02-01' = {
  name: 'website-${version}'
  location: location
  properties: {
    serverFarmId: appsServicePlan.id
  }
}
