param location string = resourceGroup().location
param skuCode string = 'F1'
param sku string = 'Free'
param websitename string
@secure()
param secretvalue string
@secure()
param websiteprincipalid string

var secretReaderRoleId = guid('customRole-secretReader')

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

resource keyVault 'Microsoft.KeyVault/vaults@2021-06-01-preview' = {
  name: 'secretstore'
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    enableRbacAuthorization: true
    tenantId: subscription().tenantId
  }
}

resource secretValue 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  parent: keyVault
  name: 'secretValue'
  properties: {
    value: secretvalue
  }
}

resource secretReaderDefinition 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' = {
  name: secretReaderRoleId
  properties: {
    roleName: 'Secret Reader'
    description: 'Allows to read the secret secretValue'
    assignableScopes: [
      subscription().id
    ]
    permissions: [
      {
        'actions': [
          'Microsoft.Authorization/*/read'
        ]
        'notActions': []
      }
    ]

  }
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  name: 'website_secretreader'
  properties: {
    roleDefinitionId: secretReaderDefinition.name
    principalId: websiteprincipalid
  }
  scope: secretValue
}
