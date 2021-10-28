param location string = resourceGroup().location
param skuCode string = 'F1'
param sku string = 'Free'
param websitename string

resource appsServicePlan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: 'websiteplan'
  location: location
  sku: {
    tier: sku
    name: skuCode 
  }
}

resource appService 'Microsoft.Web/sites@2021-02-01' = {
  name: websitename
  location: location
  properties: {
    serverFarmId: appsServicePlan.id
  }
}
