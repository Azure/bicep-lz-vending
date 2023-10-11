<!-- markdownlint-disable MD041 -->
## Example 4 - Landing Zone (Subscription) with Multiple VNets

### Bicep Module Registry

Here is a simple example Bicep file for deploying a landing zone (Subscription) with multiple spoke Virtual Networks peered to a Virtual WAN Hub using the [Bicep Module Registry](https://github.com/Azure/bicep-registry-modules):

```bicep
targetScope = 'managementGroup'

@description('Specifies the location for resources.')
param location string = 'uksouth'

module createSubAndFirstVnet 'br/public:lz/sub-vending:1.5.1' = {
  name: 'sub-with-multiple-vnets'
  params: {
    subscriptionAliasEnabled: true
    subscriptionBillingScope: '/providers/Microsoft.Billing/billingAccounts/1234567/enrollmentAccounts/123456'
    subscriptionAliasName: 'sub-bicep-lz-vending-example-004'
    subscriptionDisplayName: 'sub-bicep-lz-vending-example-004'
    subscriptionTags: {
      test: 'true'
    }
    subscriptionWorkload: 'Production'
    subscriptionManagementGroupAssociationEnabled: true
    subscriptionManagementGroupId: 'alz-landingzones-corp'
    virtualNetworkEnabled: true
    virtualNetworkLocation: location
    virtualNetworkResourceGroupName: 'rsg-${location}-net-001'
    virtualNetworkName: 'vnet-${location}-001'
    virtualNetworkAddressSpace: [
      '10.0.0.0/16'
    ]
    virtualNetworkResourceGroupLockEnabled: false
    virtualNetworkPeeringEnabled: true
    hubNetworkResourceId: '/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/rsg-uks-net-vwan-001/providers/Microsoft.Network/virtualHubs/vhub-uks-001'
  }
}

module createSubAndSecondVnet 'br/public:lz/sub-vending:1.5.1' = {
  name: 'additional-vnet'
  params: {
    subscriptionAliasEnabled: false
    existingSubscriptionId: createSubAndFirstVnet.outputs.subscriptionId
    subscriptionManagementGroupAssociationEnabled: true
    subscriptionManagementGroupId: 'alz-landingzones-corp'
    virtualNetworkEnabled: true
    virtualNetworkLocation: location
    virtualNetworkResourceGroupName: 'rsg-${location}-net-001'
    virtualNetworkName: 'vnet-${location}-002'
    virtualNetworkAddressSpace: [
      '10.1.0.0/16'
    ]
    virtualNetworkResourceGroupLockEnabled: false
    virtualNetworkPeeringEnabled: true
    hubNetworkResourceId: '/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/rsg-uks-net-vwan-001/providers/Microsoft.Network/virtualHubs/vhub-uks-001'
  }
}
```


Back to [Examples](Examples)
