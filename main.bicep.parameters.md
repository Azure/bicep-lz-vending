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
subscriptionTags | No       | An object of Tag key & value pairs to be appended to a Subscription.   > **NOTE:** Tags will only be overwriten if existing tag exists with same key as provided in this parameter; values provided here win.  - Type: `{}` Object - Default value: `{}` *(empty object)* 
virtualNetworkEnabled | No       | Whether to create a Virtual Network or not.  If set to `true` ensure you also provide values for the following parameters at a minimum:  - `virtualNetworkResourceGroupName` - `virtualNetworkResourceGroupLockEnabled` - `virtualNetworkLocation` - `virtualNetworkName` - `virtualNetworkAddressSpace`  > Other parameters may need to be set based on other parameters that you enable that are listed above. Check each parameters documentation for further information.  - Type: Boolean 
virtualNetworkResourceGroupName | No       | The name of the Resource Group to create the Virtual Network in that is created by this module.  - Type: String 
virtualNetworkResourceGroupLockEnabled | No       | Enables the deployment of a `CanNotDelete` resource locks to the Virtual Networks Resource Group that is created by this module.  - Type: Boolean 
virtualNetworkLocation | No       | The location of the virtual network. Use region shortnames e.g. `uksouth`, `eastus`, etc. Defaults to the region where the ARM/Bicep deployment is targetted to unless overridden.  - Type: String 
virtualNetworkName | No       | The name of the virtual network. The string must consist of a-z, A-Z, 0-9, -, _, and . (period) and be between 2 and 64 characters in length.  - Type: String - Default value: `''` *(empty string)* 
virtualNetworkAddressSpace | No       | The address space of the Virtual Network that will be created by this module, supplied as multiple CIDR blocks in an array, e.g. `["10.0.0.0/16","172.16.0.0/12"]`  - Type: `[]` Array - Default value: `[]` *(empty array)* 
virtualNetworkPeeringEnabled | No       | Whether to enable peering/connection with the supplied hub Virtual Network or Virtual WAN Virtual Hub.  - Type: Boolean 
hubNetworkResourceId | No       | The resource ID of the Virtual Network or Virtual WAN Hub in the hub to which the created Virtual Network, by this module, will be peered/connected to via Vitrual Network Peering or a Vitrual WAN Virtual Hub Connection.  **Example Expected Values:** - `''` (empty string) - Hub Virtual Network Resource ID: `/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/xxxxxxxxxx/providers/Microsoft.Network/virtualNetworks/xxxxxxxxxx` - Virtual WAN Virtual Hub Resource ID: `/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/xxxxxxxxxx/providers/Microsoft.Network/virtualHubs/xxxxxxxxxx`  - Type: String - Default value: `''` *(empty string)* 
virtualNetworkUseRemoteGateways | No       | Enables the use of remote gateways in the spefcified hub virtual network.  > **IMPORTANT:** If no gateways exsit in the hub virtual network, set this to `false`, otherwise peering will fail to create.  - Type: Boolean 
virtualNetworkVwanAssociatedRouteTableResourceId | No       | The resource ID of the virtual hub route table to associate to the virtual hub connection (this virtual network). If left blank/empty the `defaultRouteTable` will be associated.  - Type: String - Default value: `''` *(empty string)* = Which means if the parameter `virtualNetworkPeeringEnabled` is `true` and also the parameter `hubNetworkResourceId` is not empty then the `defaultRouteTable` will be associated of the provided Virtual Hub in the parameter `hubNetworkResourceId`.     - e.g. `/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/xxxxxxxxxx/providers/Microsoft.Network/virtualHubs/xxxxxxxxx/hubRouteTables/defaultRouteTable` 
virtualNetworkVwanPropagatedRouteTablesResourceIds | No       | An array of of objects of virtual hub route table resource IDs to propogate routes to. If left blank/empty the `defaultRouteTable` will be propogated to only.  Each object must contain the following `key`: - `id` = The Resource ID of the Virtual WAN Virtual Hub Route Table IDs you wish to propogate too  > See below [example in parameter file](#parameter-file)  > **IMPORTANT:** If you provide any Route Tables in this array of objects you must ensure you include also the `defaultRouteTable` Resource ID as an object in the array as it is not added by default when a value is provided for this parameter.  - Type: `[]` Array - Default value: `[]` *(empty array)* 
virtualNetworkVwanPropagatedLabels | No       | An array of virtual hub route table labels to propogate routes to. If left blank/empty the default label will be propogated to only.  - Type: `[]` Array - Default value: `[]` *(empty array)* 
roleAssignmentEnabled | No       | Whether to create role assignments or not. If true, supply the array of role assignment objects in the parameter called `roleAssignments`.  - Type: Boolean 
roleAssignments | No       | Supply an array of objects containing the details of the role assignments to create.  Each object must contain the following `keys`: - `principalId` = The Object ID of the User, Group, SPN, Managed Identity to assign the RBAC role too. - `definition` = The Name of built-In RBAC Roles or a Resource ID of a Built-in or custom RBAC Role Defintion. - `relativeScope` = 2 options can be provided for input value:     1. `''` *(empty string)* = Make RBAC Role Assignment to Subscription scope     2. `'/resourceGroups/<RESOURCE GROUP NAME>'` = Make RBAC Role Assignment to specified Resource Group  > See below [example in parameter file](#parameter-file) of various combinations  - Type: `[]` Array - Default value: `[]` *(empty array)* 

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

An object of Tag key & value pairs to be appended to a Subscription. 

> **NOTE:** Tags will only be overwriten if existing tag exists with same key as provided in this parameter; values provided here win.

- Type: `{}` Object
- Default value: `{}` *(empty object)*


### virtualNetworkEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Whether to create a Virtual Network or not.

If set to `true` ensure you also provide values for the following parameters at a minimum:

- `virtualNetworkResourceGroupName`
- `virtualNetworkResourceGroupLockEnabled`
- `virtualNetworkLocation`
- `virtualNetworkName`
- `virtualNetworkAddressSpace`

> Other parameters may need to be set based on other parameters that you enable that are listed above. Check each parameters documentation for further information.

- Type: Boolean


- Default value: `False`

### virtualNetworkResourceGroupName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The name of the Resource Group to create the Virtual Network in that is created by this module.

- Type: String


### virtualNetworkResourceGroupLockEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Enables the deployment of a `CanNotDelete` resource locks to the Virtual Networks Resource Group that is created by this module.

- Type: Boolean


- Default value: `True`

### virtualNetworkLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The location of the virtual network. Use region shortnames e.g. `uksouth`, `eastus`, etc. Defaults to the region where the ARM/Bicep deployment is targetted to unless overridden.

- Type: String


- Default value: `[deployment().location]`

### virtualNetworkName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The name of the virtual network. The string must consist of a-z, A-Z, 0-9, -, _, and . (period) and be between 2 and 64 characters in length.

- Type: String
- Default value: `''` *(empty string)*


### virtualNetworkAddressSpace

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The address space of the Virtual Network that will be created by this module, supplied as multiple CIDR blocks in an array, e.g. `["10.0.0.0/16","172.16.0.0/12"]`

- Type: `[]` Array
- Default value: `[]` *(empty array)*


### virtualNetworkPeeringEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Whether to enable peering/connection with the supplied hub Virtual Network or Virtual WAN Virtual Hub.

- Type: Boolean


- Default value: `False`

### hubNetworkResourceId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The resource ID of the Virtual Network or Virtual WAN Hub in the hub to which the created Virtual Network, by this module, will be peered/connected to via Vitrual Network Peering or a Vitrual WAN Virtual Hub Connection.

**Example Expected Values:**
- `''` (empty string)
- Hub Virtual Network Resource ID: `/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/xxxxxxxxxx/providers/Microsoft.Network/virtualNetworks/xxxxxxxxxx`
- Virtual WAN Virtual Hub Resource ID: `/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/xxxxxxxxxx/providers/Microsoft.Network/virtualHubs/xxxxxxxxxx`

- Type: String
- Default value: `''` *(empty string)*


### virtualNetworkUseRemoteGateways

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Enables the use of remote gateways in the spefcified hub virtual network.

> **IMPORTANT:** If no gateways exsit in the hub virtual network, set this to `false`, otherwise peering will fail to create.

- Type: Boolean


- Default value: `True`

### virtualNetworkVwanAssociatedRouteTableResourceId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The resource ID of the virtual hub route table to associate to the virtual hub connection (this virtual network). If left blank/empty the `defaultRouteTable` will be associated.

- Type: String
- Default value: `''` *(empty string)* = Which means if the parameter `virtualNetworkPeeringEnabled` is `true` and also the parameter `hubNetworkResourceId` is not empty then the `defaultRouteTable` will be associated of the provided Virtual Hub in the parameter `hubNetworkResourceId`.
    - e.g. `/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/xxxxxxxxxx/providers/Microsoft.Network/virtualHubs/xxxxxxxxx/hubRouteTables/defaultRouteTable`


### virtualNetworkVwanPropagatedRouteTablesResourceIds

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An array of of objects of virtual hub route table resource IDs to propogate routes to. If left blank/empty the `defaultRouteTable` will be propogated to only.

Each object must contain the following `key`:
- `id` = The Resource ID of the Virtual WAN Virtual Hub Route Table IDs you wish to propogate too

> See below [example in parameter file](#parameter-file)

> **IMPORTANT:** If you provide any Route Tables in this array of objects you must ensure you include also the `defaultRouteTable` Resource ID as an object in the array as it is not added by default when a value is provided for this parameter.

- Type: `[]` Array
- Default value: `[]` *(empty array)*


### virtualNetworkVwanPropagatedLabels

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An array of virtual hub route table labels to propogate routes to. If left blank/empty the default label will be propogated to only.

- Type: `[]` Array
- Default value: `[]` *(empty array)*


### roleAssignmentEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Whether to create role assignments or not. If true, supply the array of role assignment objects in the parameter called `roleAssignments`.

- Type: Boolean


- Default value: `False`

### roleAssignments

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Supply an array of objects containing the details of the role assignments to create.

Each object must contain the following `keys`:
- `principalId` = The Object ID of the User, Group, SPN, Managed Identity to assign the RBAC role too.
- `definition` = The Name of built-In RBAC Roles or a Resource ID of a Built-in or custom RBAC Role Defintion.
- `relativeScope` = 2 options can be provided for input value:
    1. `''` *(empty string)* = Make RBAC Role Assignment to Subscription scope
    2. `'/resourceGroups/<RESOURCE GROUP NAME>'` = Make RBAC Role Assignment to specified Resource Group

> See below [example in parameter file](#parameter-file) of various combinations

- Type: `[]` Array
- Default value: `[]` *(empty array)*


## Outputs

Name | Type | Description
---- | ---- | -----------
subscriptionId | string | The Subscription ID that has been created or provided.
subscriptionResourceId | string | The Subscription Resource ID that has been created or provided.

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
            "value": {
                "tagKey1": "value",
                "tag-key-2": "value"
            }
        },
        "virtualNetworkEnabled": {
            "value": true
        },
        "virtualNetworkResourceGroupName": {
            "value": "rg-networking-001"
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
        "virtualNetworkAddressSpace": {
            "value": [
                "10.0.0.0/16"
            ]
        },
        "virtualNetworkPeeringEnabled": {
            "value": true
        },
        "hubNetworkResourceId": {
            "value": "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/xxxxxxxxxx/providers/Microsoft.Network/virtualNetworks/xxxxxxxxxx"
        },
        "virtualNetworkUseRemoteGateways": {
            "value": true
        },
        "virtualNetworkVwanAssociatedRouteTableResourceId": {
            "value": "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/xxxxxxxxxx/providers/Microsoft.Network/virtualHubs/xxxxxxxxx/hubRouteTables/xxxxxxxxx"
        },
        "virtualNetworkVwanPropagatedRouteTablesResourceIds": {
            "value": [
                {
                    "id": "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/xxxxxxxxxx/providers/Microsoft.Network/virtualHubs/xxxxxxxxx/hubRouteTables/defaultRouteTable"
                },
                {
                    "id": "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/xxxxxxxxxx/providers/Microsoft.Network/virtualHubs/xxxxxxxxx/hubRouteTables/xxxxxxxxx"
                }
            ]
        },
        "virtualNetworkVwanPropagatedLabels": {
            "value": [
                "default",
                "anotherLabel"
            ]
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
                    "principalId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
                    "definition": "/providers/Microsoft.Authorization/roleDefinitions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
                    "relativeScope": ""
                },
                {
                    "principalId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
                    "definition": "Reader",
                    "relativeScope": "/resourceGroups/rsg-networking-001"
                },
                {
                    "principalId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
                    "definition": "/providers/Microsoft.Authorization/roleDefinitions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
                    "relativeScope": "/resourceGroups/rsg-networking-001"
                }
            ]
        }
    }
}
```
