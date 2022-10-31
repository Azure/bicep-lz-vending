<!-- markdownlint-disable MD041 -->
## Example 3 - Landing Zone (Subscription) using an existing Subscription

Here is a simple example parameter file for deploying a landing zone (Subscription) with a spoke Virtual Network connected to a Virtual WAN Hub:

> Note the Virtual WAN routing configuration here will use the defaults. Meaning the Virtual Hub Connection will be associated to the default route table and the default label. For advanced routing configuration, see the examples in the [`main.bicep` module parameters documentation](../../main.bicep.parameters.md)

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "subscriptionAliasEnabled": {
      "value": false
    },
    "subscriptionDisplayName": {
      "value": ""
    },
    "subscriptionAliasName": {
      "value": ""
    },
    "subscriptionBillingScope": {
      "value": ""
    },
    "subscriptionWorkload": {
      "value": ""
    },
    "existingSubscriptionId": {
      "value": "xxxxxxxx-yyyy-zzzz-yyyy-xxxxxxxxxxxx"
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
      "value": "vnet-example-001"
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
        "10.0.0.0/16"
      ]
    },
    "virtualNetworkPeeringEnabled": {
      "value": true
    },
    "hubNetworkResourceId": {
      "value": "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/rg-hub-network-001/providers/Microsoft.Network/virtualNetworks/vnet-hub-001"
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
