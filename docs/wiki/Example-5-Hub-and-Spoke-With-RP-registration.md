<!-- markdownlint-disable MD041 -->
## Example 5 - Landing Zone (Subscription) with a spoke Virtual Network peered to a Hub Virtual Network and resource providers and features registration

### Bicep Module Registry

Here is a simple example Bicep file for deploying a landing zone (Subscription) with a spoke Virtual Network peered to a Hub Virtual Network, resource providers and features registration using the [Bicep Module Registry](https://github.com/Azure/bicep-registry-modules):

> A resoure group gets created in the subscription with the format "rsg-<location>-ds-<xxxx>" hosting a deployment script and a user-assigned managed identity. This resource group needs to be manually deleted if not needed after the resource providers features registration process.

> The resource providers registration process is asyncronous as it might take extended periods of time to register.

> After a preview feature is registered in your subscription, you'll see one of two states: Registered or Pending.
>
> - For a preview feature that doesn't require approval, the state is Registered.
> - If a preview feature requires approval, the registration state is Pending. You must request approval from the Azure service offering the preview feature. Usually, you request access through a support ticket.

```bicep
targetScope = 'managementGroup'

@description('Specifies the location for resources.')
param location string = 'uksouth'

module sub003 'br/public:lz/sub-vending:1.5.1' = {
  name: 'sub-bicep-lz-vending-example-001'
  params: {
    subscriptionAliasEnabled: true
    subscriptionBillingScope: '/providers/Microsoft.Billing/billingAccounts/1234567/enrollmentAccounts/123456'
    subscriptionAliasName: 'sub-bicep-lz-vending-example-001'
    subscriptionDisplayName: 'sub-bicep-lz-vending-example-001'
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
    hubNetworkResourceId: '/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/rsg-uks-net-hub-001/providers/Microsoft.Network/virtualNetworks/vnet-uks-hub-001'
    resourceProviders : {
      'Microsoft.Compute' : ['InGuestHotPatchVMPreview']
      'Microsoft.AVS'     : ['AzureServicesVm','ArcAutomatedOnboarding']
    }
  }
}
```

### ARM JSON Parameter File

Here is a simple example parameter file for deploying a landing zone (Subscription) with a spoke Virtual Network peered to a Hub Virtual Network, resource providers and features registration:

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "subscriptionAliasEnabled": {
      "value": true
    },
    "subscriptionDisplayName": {
      "value": "sub-bicep-lz-vending-example-001"
    },
    "subscriptionAliasName": {
      "value": "sub-bicep-lz-vending-example-001"
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
    "resourceProviders":{
      "value":{
        "Microsoft.Compute": ["InGuestHotPatchVMPreview"],
        "Microsoft.AVS" : ["AzureServicesVm","ArcAutomatedOnboarding"]
      }
    },
    "disableTelemetry": {
      "value": false
    }
  }
}
```

Back to [Examples](Examples)
