# `main.bicep` Parameters

These are the input parameters for the Bicep module: [`main.bicep`](./main.bicep)

> For more information and examples please see the [wiki](https://github.com/Azure/bicep-lz-vending/wiki)

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
subscriptionAliasEnabled | No       | Whether to create a new subscription using the subscription alias resource. If false, supply the existingSubscriptionId parameter instead to deploy resources to an existing subscription.
subscriptionDisplayName | Yes      | The name of the subscription alias. The string must be comprised of a-z, A-Z, 0-9, - and _. The maximum length is 63 characters.
subscriptionAliasName | Yes      | The name of the subscription alias. The string must be comprised of a-z, A-Z, 0-9, -, _ and space. The maximum length is 63 characters.
subscriptionBillingScope | Yes      | The billing scope for the new subscription alias. A valid billing scope starts with `/providers/Microsoft.Billing/billingAccounts/` and is case sensitive.
subscriptionWorkload | No       | The workload type can be either `Production` or `DevTest` and is case sensitive.
exisitingSubscriptionId | No       | An existing subscription ID. Use this when you do not want the module to create a new subscription. But do want to manage the management group membership. A subscription ID should be provided in the example format `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`.
subscriptionManagementGroupAssociationEnabled | No       | Whether to move the subscription to the specified management group supplied in the pararmeter subscriptionManagementGroupId.
subscriptionManagementGroupId | No       | The destination management group ID for the new subscription. Note: Do not supply the display name. The management group ID forms part of the Azure resource ID. e.g., `/providers/Microsoft.Management/managementGroups/{managementGroupId}`.
subscriptionTags | No       | An object of tag key/value pairs to be appended to a subscription. NOTE: Tags will only be overwriten if existing tag exists with same key; values provided here win.
virtualNetworkEnabled | No       | Whether to create a virtual network or not.
virtualNetworkResourceGroupName | No       | The name of the resource group to create the virtual network in.
virtualNetworkResourceGroupLockEnabled | No       | Enables the deployment of a `CanNotDelete` resource locks to the virtual networks resource group.
virtualNetworkLocation | No       | The location of the virtual network. Use region shortnames e.g. uksouth, eastus, etc.
virtualNetworkName | Yes      | The name of the virtual network. The string must consist of a-z, A-Z, 0-9, -, _, and . (period) and be between 2 and 64 characters in length.
virtualNetworkAddressSpace | Yes      | The address space of the virtual network, supplied as multiple CIDR blocks, e.g. `["10.0.0.0/16","172.16.0.0/12"]`
virtualNetworkPeeringEnabled | No       | Whether to enable peering/connection with the supplied hub virtual network or virtual hub.
hubNetworkResourceId | No       | The resource ID of the virtual network or virtual wan hub in the hub to which the created virtual network will be peered/connected to via vitrual network peering or a vitrual hub connection.
virtualNetworkUseRemoteGateways | No       | Enables the use of remote gateways in the spefcified hub virtual network. If no gateways exsit in the hub virtual network, set this to false, otherwise peering will fail to create.
virtualNetworkVwanAssociatedRouteTableResourceId | No       | The resource ID of the virtual hub route table to associate to the virtual hub connection (this virtual network). If left blank/empty default route table will be associated.
virtualNetworkVwanPropagatedRouteTablesResourceIds | No       | An array of virtual hub route table resource IDs to propogate routes to. If left blank/empty default route table will be propogated to only.
virtualNetworkVwanPropagatedLabels | No       | An array of virtual hub route table labels to propogate routes to. If left blank/empty default label will be propogated to only.

### subscriptionAliasEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Whether to create a new subscription using the subscription alias resource. If false, supply the existingSubscriptionId parameter instead to deploy resources to an existing subscription.

- Default value: `True`

### subscriptionDisplayName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

The name of the subscription alias. The string must be comprised of a-z, A-Z, 0-9, - and _. The maximum length is 63 characters.

### subscriptionAliasName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

The name of the subscription alias. The string must be comprised of a-z, A-Z, 0-9, -, _ and space. The maximum length is 63 characters.

### subscriptionBillingScope

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

The billing scope for the new subscription alias. A valid billing scope starts with `/providers/Microsoft.Billing/billingAccounts/` and is case sensitive.

### subscriptionWorkload

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The workload type can be either `Production` or `DevTest` and is case sensitive.

- Default value: `Production`

- Allowed values: `DevTest`, `Production`

### exisitingSubscriptionId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An existing subscription ID. Use this when you do not want the module to create a new subscription. But do want to manage the management group membership. A subscription ID should be provided in the example format `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`.

### subscriptionManagementGroupAssociationEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Whether to move the subscription to the specified management group supplied in the pararmeter subscriptionManagementGroupId.

- Default value: `True`

### subscriptionManagementGroupId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The destination management group ID for the new subscription. Note: Do not supply the display name. The management group ID forms part of the Azure resource ID. e.g., `/providers/Microsoft.Management/managementGroups/{managementGroupId}`.

### subscriptionTags

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An object of tag key/value pairs to be appended to a subscription. NOTE: Tags will only be overwriten if existing tag exists with same key; values provided here win.

### virtualNetworkEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Whether to create a virtual network or not.

- Default value: `False`

### virtualNetworkResourceGroupName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The name of the resource group to create the virtual network in.

### virtualNetworkResourceGroupLockEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Enables the deployment of a `CanNotDelete` resource locks to the virtual networks resource group.

- Default value: `True`

### virtualNetworkLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The location of the virtual network. Use region shortnames e.g. uksouth, eastus, etc.

- Default value: `[deployment().location]`

### virtualNetworkName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

The name of the virtual network. The string must consist of a-z, A-Z, 0-9, -, _, and . (period) and be between 2 and 64 characters in length.

### virtualNetworkAddressSpace

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

The address space of the virtual network, supplied as multiple CIDR blocks, e.g. `["10.0.0.0/16","172.16.0.0/12"]`

### virtualNetworkPeeringEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Whether to enable peering/connection with the supplied hub virtual network or virtual hub.

- Default value: `False`

### hubNetworkResourceId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The resource ID of the virtual network or virtual wan hub in the hub to which the created virtual network will be peered/connected to via vitrual network peering or a vitrual hub connection.

### virtualNetworkUseRemoteGateways

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Enables the use of remote gateways in the spefcified hub virtual network. If no gateways exsit in the hub virtual network, set this to false, otherwise peering will fail to create.

- Default value: `True`

### virtualNetworkVwanAssociatedRouteTableResourceId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The resource ID of the virtual hub route table to associate to the virtual hub connection (this virtual network). If left blank/empty default route table will be associated.

### virtualNetworkVwanPropagatedRouteTablesResourceIds

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An array of virtual hub route table resource IDs to propogate routes to. If left blank/empty default route table will be propogated to only.

### virtualNetworkVwanPropagatedLabels

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An array of virtual hub route table labels to propogate routes to. If left blank/empty default label will be propogated to only.

## Outputs

Name | Type | Description
---- | ---- | -----------
subscriptionId | string |
subscriptionResourceId | string |

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "main.json"
    },
    "parameters": {
        "subscriptionAliasEnabled": {
            "value": true
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
            "value": "Production"
        },
        "exisitingSubscriptionId": {
            "value": ""
        },
        "subscriptionManagementGroupAssociationEnabled": {
            "value": true
        },
        "subscriptionManagementGroupId": {
            "value": ""
        },
        "subscriptionTags": {
            "value": {}
        },
        "virtualNetworkEnabled": {
            "value": false
        },
        "virtualNetworkResourceGroupName": {
            "value": ""
        },
        "virtualNetworkResourceGroupLockEnabled": {
            "value": true
        },
        "virtualNetworkLocation": {
            "value": "[deployment().location]"
        },
        "virtualNetworkName": {
            "value": ""
        },
        "virtualNetworkAddressSpace": {
            "value": []
        },
        "virtualNetworkPeeringEnabled": {
            "value": false
        },
        "hubNetworkResourceId": {
            "value": ""
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
        }
    }
}
```
