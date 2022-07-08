param location string = resourceGroup().location
param skuCode string = 'F1'
param sku string = 'Free'
param websitename string
param keyvaultname string
@secure()
param secretValue string
param secretName string
param extra string

var roles = {
  'Key Vault Secret Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4633458b-17de-408a-b874-0445c86b69e6')
}
var secretUserRoleAssignmentName = guid(roles['Key Vault Secret Reader'], 'Managed identity')
var kv_reference = '@Microsoft.KeyVault(VaultName=${keyvaultname};SecretName=${secretName})'

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
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: appsServicePlan.id
    siteConfig: {
      appSettings: [
        {
          name: 'SecretValue'
          value: kv_reference
        }
      ]
    }
  }
}

resource keyVault 'Microsoft.KeyVault/vaults@2021-06-01-preview' = {
  name: keyvaultname
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

resource kv_secretValue 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  parent: keyVault
  name: secretName
  properties: {
    value: secretValue
  }
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-08-01-preview' = {
  scope: kv_secretValue
  name: secretUserRoleAssignmentName
  properties: {
    roleDefinitionId: roles['Key Vault Secret Reader']
    principalId: appService.identity.principalId
    principalType: 'ServicePrincipal'
  }
}
