<!-- markdownlint-disable MD041 -->
## Example 2 - Landing Zone (Subscription) with a spoke Virtual Network connected to a Virtual WAN Hub

### Bicep Module Registry

Here is a simple example Bicep file for deploying a landing zone (Subscription) with a spoke Virtual Network peered to a Virtual WAN Hub using the [Bicep Module Registry](https://github.com/Azure/bicep-registry-modules):

```bicep
targetScope = 'managementGroup'

@description('Specifies the location for resources.')
param location string = 'uksouth'

module sub002 'br/public:lz/sub-vending:1.3.1' = {
  name: 'sub-bicep-lz-vending-example-002'
  params: {
    subscriptionAliasEnabled: true
    subscriptionBillingScope: '/providers/Microsoft.Billing/billingAccounts/1234567/enrollmentAccounts/123456'
    subscriptionAliasName: 'sub-bicep-lz-vending-example-002'
    subscriptionDisplayName: 'sub-bicep-lz-vending-example-002'
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
      '10.1.0.0/24'
    ]
    virtualNetworkResourceGroupLockEnabled: true
    virtualNetworkPeeringEnabled: true
    hubNetworkResourceId: '/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/rsg-uks-net-vwan-001/providers/Microsoft.Network/virtualHubs/vhub-uks-001'
  }
}
```

### ARM JSON Parameter File

Here is a simple example parameter file for deploying a landing zone (Subscription) with a spoke Virtual Network connected to a Virtual WAN Hub:

> Note the Virtual WAN routing configuration here will use the defaults. Meaning the Virtual Hub Connection will be associated to the default route table and the default label. For advanced routing configuration, see the examples in the [`main.bicep` module parameters documentation](../../main.bicep.parameters.md)

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "subscriptionAliasEnabled": {
      "value": true
    },
    "subscriptionDisplayName": {
      "value": "sub-bicep-lz-vending-example-002"
    },
    "subscriptionAliasName": {
      "value": "sub-bicep-lz-vending-example-002"
    },
    "subscriptionBillingScope": {
      "value": "providers/Microsoft.Billing/billingAccounts/1234567/enrollmentAccounts/123456"
    },
    "subscriptionWorkload": {
      "value": "Production"
    },
    "existingSubscriptionId": {
      "value": ""
    },
    "subscriptionManagementGroupAssociationEnabled": {
      "value": true
    },
    "subscriptionManagementGroupId": {
      "value": "alz-landingzones-corp"
    },
    "subscriptionTags": {
      "value": {
        "Cost-Center": "ABC123",
        "Usage": "Example"
      }
    },
    "virtualNetworkEnabled": {
      "value": true
    },
    "virtualNetworkResourceGroupName": {
      "value": "rg-networking-001"
    },
    "virtualNetworkResourceGroupTags": {
      "value": {
        "Cost-Center": "ABC123",
        "Usage": "Example",
        "Managed-By": "Platform Team"
      }
    },
    "virtualNetworkResourceGroupLockEnabled": {
      "value": true
    },
    "virtualNetworkLocation": {
      "value": "uksouth"
    },
    "virtualNetworkName": {
      "value": "vnet-example-002"
    },
    "virtualNetworkTags": {
      "value": {
        "Cost-Center": "ABC123",
        "Usage": "Example",
        "Managed-By": "Platform Team"
      }
    },
    "virtualNetworkAddressSpace": {
      "value": [
        "10.1.0.0/24"
      ]
    },
    "virtualNetworkDnsServers": {
      "value": [
        "10.4.1.4",
        "10.2.1.5"
      ]
    },
    "virtualNetworkDdosPlanId": {
      "value": "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/rg-hub-network-001/providers/Microsoft.Network/ddosProtectionPlans/ddos-001"
    },
    "virtualNetworkPeeringEnabled": {
      "value": true
    },
    "hubNetworkResourceId": {
      "value": "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/rg-hub-network-001/providers/Microsoft.Network/virtualHubs/vhub-uks-001"
    },
    "virtualNetworkUseRemoteGateways": {
      "value": true
    },
    "virtualNetworkVwanAssociatedRouteTableResourceId": {
      "value": ""
    },
    "virtualNetworkVwanPropagatedRouteTablesResourceIds": {
      "value": []
    },
    "virtualNetworkVwanPropagatedLabels": {
      "value": []
    },
    "roleAssignmentEnabled": {
      "value": true
    },
    "roleAssignments": {
      "value": [
        {
          "principalId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
          "definition": "Contributor",
          "relativeScope": ""
        },
        {
          "principalId": "yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy",
          "definition": "/providers/Microsoft.Authorization/roleDefinitions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
          "relativeScope": ""
        },
        {
          "principalId": "zzzzzzzz-zzzz-zzzz-zzzz-zzzzzzzzzzzz",
          "definition": "Reader",
          "relativeScope": "/resourceGroups/rg-networking-001"
        }
      ]
    },
    "disableTelemetry": {
      "value": false
    }
  }
}
```

Back to [Examples](Examples)
