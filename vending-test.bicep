targetScope = 'managementGroup'

@description('Specifies the location for resources.')
param location string = 'eastus'

module sub003 'main.bicep' = {
  name: 'sub003'
  params: {
    subscriptionAliasEnabled: false
    existingSubscriptionId: 'e3b447fd-b561-4fa4-a821-4f90799ba35d'
    subscriptionTags: {
      test: 'true'
    }
    subscriptionManagementGroupAssociationEnabled: false
    virtualNetworkEnabled: true
    virtualNetworkLocation: location
    virtualNetworkResourceGroupName: 'rsg-${location}-net-001'
    virtualNetworkName: 'vnet-${location}-001'
    virtualNetworkAddressSpace: [
      '10.0.0.0/16'
    ]
    virtualNetworkResourceGroupLockEnabled: false
    virtualNetworkPeeringEnabled: false
    resourceProviders : {
      'Microsoft.Compute' : ['aykalam']
      'Microsoft.Computational' : []
    }
  }
}
