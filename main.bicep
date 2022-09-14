targetScope = 'managementGroup'

// PARAMETERS

// Subscription Parameters
@description('Whether to create a new subscription using the subscription alias resource. If false, supply the existingSubscriptionId parameter instead to deploy resources to an existing subscription.')
param subscriptionAliasEnabled bool = true

@maxLength(63)
@description('The name of the subscription alias. The string must be comprised of a-z, A-Z, 0-9, - and _. The maximum length is 63 characters.')
param subscriptionDisplayName string

@maxLength(63)
@description('The name of the subscription alias. The string must be comprised of a-z, A-Z, 0-9, -, _ and space. The maximum length is 63 characters.')
param subscriptionAliasName string

@description('The billing scope for the new subscription alias. A valid billing scope starts with `/providers/Microsoft.Billing/billingAccounts/` and is case sensitive.')
param subscriptionBillingScope string

@allowed([
  'DevTest'
  'Production'
])
@description('The workload type can be either `Production` or `DevTest` and is case sensitive.')
param subscriptionWorkload string = 'Production'

@maxLength(36)
@description('An existing subscription ID. Use this when you do not want the module to create a new subscription. But do want to manage the management group membership. A subscription ID should be provided in the example format `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`.')
param exisitingSubscriptionId string = ''

// Subscription Resources Wrapper Parameters

@description('Whether to move the subscription to the specified management group supplied in the pararmeter subscriptionManagementGroupId.')
param subscriptionManagementGroupAssociationEnabled bool = true

@description('The destination management group ID for the new subscription. Note: Do not supply the display name. The management group ID forms part of the Azure resource ID. e.g., `/providers/Microsoft.Management/managementGroups/{managementGroupId}`.')
param subscriptionManagementGroupId string = ''

@metadata({
  example: {
    tagKey1: 'value'
    'tag-key-2': 'value'
  }
})
@description('''An object of Tag key & value pairs to be appended to a Subscription. 

> **NOTE:** Tags will only be overwriten if existing tag exists with same key as provided in this parameter; values provided here win.

- Type: `{}` Object
- Default value: `{}` *(empty object)*
''')
param subscriptionTags object = {}

@metadata({
  example: true
})
@description('''Whether to create a Virtual Network or not.

If set to `true` ensure you also provide values for the following parameters at a minimum:

- `virtualNetworkResourceGroupName`
- `virtualNetworkResourceGroupLockEnabled`
- `virtualNetworkLocation`
- `virtualNetworkName`
- `virtualNetworkAddressSpace`

> Other parameters may need to be set based on other parameters that you enable that are listed above. Check each parameters documentation for further information.

- Type: Boolean
''')
param virtualNetworkEnabled bool = false

@metadata({
  example: 'rg-networking-001'
})
@maxLength(90)
@description('''The name of the Resource Group to create the Virtual Network in that is created by this module.

- Type: String
''')
param virtualNetworkResourceGroupName string = ''

@metadata({
  example: true
})
@description('''Enables the deployment of a `CanNotDelete` resource locks to the Virtual Networks Resource Group that is created by this module.

- Type: Boolean
''')
param virtualNetworkResourceGroupLockEnabled bool = true

@metadata({
  example: 'uksouth'
})
@description('''The location of the virtual network. Use region shortnames e.g. `uksouth`, `eastus`, etc. Defaults to the region where the ARM/Bicep deployment is targetted to unless overridden.

- Type: String
''')
param virtualNetworkLocation string = deployment().location

@metadata({
  example: 'vnet-example-001'
})
@maxLength(64)
@description('''The name of the virtual network. The string must consist of a-z, A-Z, 0-9, -, _, and . (period) and be between 2 and 64 characters in length.

- Type: String
- Default value: `''` *(empty string)*
''')
param virtualNetworkName string = ''

@metadata({
  example: [
    '10.0.0.0/16'
  ]
})
@description('''The address space of the Virtual Network that will be created by this module, supplied as multiple CIDR blocks in an array, e.g. `["10.0.0.0/16","172.16.0.0/12"]`

- Type: `[]` Array
- Default value: `[]` *(empty array)*
''')
param virtualNetworkAddressSpace array = []

@metadata({
  example: true
})
@description('''Whether to enable peering/connection with the supplied hub Virtual Network or Virtual WAN Virtual Hub.

- Type: Boolean
''')
param virtualNetworkPeeringEnabled bool = false

@metadata({
  example: '/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/xxxxxxxxxx/providers/Microsoft.Network/virtualNetworks/xxxxxxxxxx'
})
@description('''The resource ID of the Virtual Network or Virtual WAN Hub in the hub to which the created Virtual Network, by this module, will be peered/connected to via Vitrual Network Peering or a Vitrual WAN Virtual Hub Connection.

**Example Expected Values:**
- `''` (empty string)
- Hub Virtual Network Resource ID: `/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/xxxxxxxxxx/providers/Microsoft.Network/virtualNetworks/xxxxxxxxxx`
- Virtual WAN Virtual Hub Resource ID: `/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/xxxxxxxxxx/providers/Microsoft.Network/virtualHubs/xxxxxxxxxx`

- Type: String
- Default value: `''` *(empty string)*
''')
param hubNetworkResourceId string = ''

@metadata({
  example: true
})
@description('''Enables the use of remote gateways in the spefcified hub virtual network.

> **IMPORTANT:** If no gateways exsit in the hub virtual network, set this to `false`, otherwise peering will fail to create.

- Type: Boolean
''')
param virtualNetworkUseRemoteGateways bool = true

@metadata({
  example: '/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/xxxxxxxxxx/providers/Microsoft.Network/virtualHubs/xxxxxxxxx/hubRouteTables/xxxxxxxxx'
})
@description('''The resource ID of the virtual hub route table to associate to the virtual hub connection (this virtual network). If left blank/empty the `defaultRouteTable` will be associated.

- Type: String
- Default value: `''` *(empty string)* = Which means if the parameter `virtualNetworkPeeringEnabled` is `true` and also the parameter `hubNetworkResourceId` is not empty then the `defaultRouteTable` will be associated of the provided Virtual Hub in the parameter `hubNetworkResourceId`.
    - e.g. `/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/xxxxxxxxxx/providers/Microsoft.Network/virtualHubs/xxxxxxxxx/hubRouteTables/defaultRouteTable`
''')
param virtualNetworkVwanAssociatedRouteTableResourceId string = ''

@metadata({
  example: [
    {
      id: '/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/xxxxxxxxxx/providers/Microsoft.Network/virtualHubs/xxxxxxxxx/hubRouteTables/defaultRouteTable'
    }
    {
      id: '/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/xxxxxxxxxx/providers/Microsoft.Network/virtualHubs/xxxxxxxxx/hubRouteTables/xxxxxxxxx'
    }
  ]
})
@description('''An array of of objects of virtual hub route table resource IDs to propogate routes to. If left blank/empty the `defaultRouteTable` will be propogated to only.

Each object must contain the following `key`:
- `id` = The Resource ID of the Virtual WAN Virtual Hub Route Table IDs you wish to propogate too

> See below [example in parameter file](#parameter-file)

> **IMPORTANT:** If you provide any Route Tables in this array of objects you must ensure you include also the `defaultRouteTable` Resource ID as an object in the array as it is not added by default when a value is provided for this parameter.

- Type: `[]` Array
- Default value: `[]` *(empty array)*
''')
param virtualNetworkVwanPropagatedRouteTablesResourceIds array = []

@metadata({
  example: [
    'default'
    'anotherLabel'
  ]
})
@description('''An array of virtual hub route table labels to propogate routes to. If left blank/empty the default label will be propogated to only.

- Type: `[]` Array
- Default value: `[]` *(empty array)*
''')
param virtualNetworkVwanPropagatedLabels array = []

@metadata({
  example: true
})
@description('''Whether to create role assignments or not. If true, supply the array of role assignment objects in the parameter called `roleAssignments`.

- Type: Boolean
''')
param roleAssignmentEnabled bool = false

@metadata({
  example: [
    {
      principalId: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
      definition: 'Contributor'
      relativeScope: ''
    }
    {
      principalId: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
      definition: '/providers/Microsoft.Authorization/roleDefinitions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
      relativeScope: ''
    }
    {
      principalId: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
      definition: 'Reader'
      relativeScope: '/resourceGroups/rsg-networking-001'
    }
    {
      principalId: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
      definition: '/providers/Microsoft.Authorization/roleDefinitions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
      relativeScope: '/resourceGroups/rsg-networking-001'
    }
  ]
})
@description('''Supply an array of objects containing the details of the role assignments to create.

Each object must contain the following `keys`:
- `principalId` = The Object ID of the User, Group, SPN, Managed Identity to assign the RBAC role too.
- `definition` = The Name of built-In RBAC Roles or a Resource ID of a Built-in or custom RBAC Role Defintion.
- `relativeScope` = 2 options can be provided for input value:
    1. `''` *(empty string)* = Make RBAC Role Assignment to Subscription scope
    2. `'/resourceGroups/<RESOURCE GROUP NAME>'` = Make RBAC Role Assignment to specified Resource Group

> See below [example in parameter file](#parameter-file) of various combinations

- Type: `[]` Array
- Default value: `[]` *(empty array)*
''')
param roleAssignments array = []

// VARIABLES

var existingSubscriptionIDEmptyCheck = empty(exisitingSubscriptionId) ? 'No Subscription ID Provided' : exisitingSubscriptionId

// Deployment name variables
// LIMITS: Tenant = 64, Management Group = 64, Subscription = 64, Resource Group = 64
var deploymentNames = {
  createSubscription: take('lz-vend-sub-create-${subscriptionAliasName}-${uniqueString(subscriptionAliasName, subscriptionDisplayName, subscriptionBillingScope, subscriptionWorkload, deployment().name)}', 64)
  createSubscriptionResources: take('lz-vend-sub-res-create-${subscriptionAliasName}-${uniqueString(subscriptionAliasName, subscriptionDisplayName, subscriptionBillingScope, subscriptionWorkload, deployment().name)}', 64)
}

// RESOURCES & MODULES

module createSubscription 'src/self/Microsoft.Subscription/aliases/deploy.bicep' = if (subscriptionAliasEnabled && empty(exisitingSubscriptionId)) {
  scope: tenant()
  name: deploymentNames.createSubscription
  params: {
    subscriptionBillingScope: subscriptionBillingScope
    subscriptionAliasName: subscriptionAliasName
    subscriptionDisplayName: subscriptionDisplayName
    subscriptionWorkload: subscriptionWorkload
  }
}

module createSubscriptionResources 'src/self/subResourceWrapper/deploy.bicep' = if ((subscriptionAliasEnabled || !empty(exisitingSubscriptionId)) && virtualNetworkEnabled && !empty(virtualNetworkResourceGroupName)) {
  name: deploymentNames.createSubscriptionResources
  params: {
    subscriptionId: (subscriptionAliasEnabled && empty(exisitingSubscriptionId)) ? createSubscription.outputs.subscriptionId : exisitingSubscriptionId
    subscriptionManagementGroupAssociationEnabled: subscriptionManagementGroupAssociationEnabled
    subscriptionManagementGroupId: subscriptionManagementGroupId
    subscriptionTags: subscriptionTags
    virtualNetworkEnabled: virtualNetworkEnabled
    virtualNetworkResourceGroupName: virtualNetworkResourceGroupName
    virtualNetworkResourceGroupLockEnabled: virtualNetworkResourceGroupLockEnabled
    virtualNetworkLocation: virtualNetworkLocation
    virtualNetworkName: virtualNetworkName
    virtualNetworkAddressSpace: virtualNetworkAddressSpace
    virtualNetworkPeeringEnabled: virtualNetworkPeeringEnabled
    hubNetworkResourceId: hubNetworkResourceId
    virtualNetworkUseRemoteGateways: virtualNetworkUseRemoteGateways
    virtualNetworkVwanAssociatedRouteTableResourceId: virtualNetworkVwanAssociatedRouteTableResourceId
    virtualNetworkVwanPropagatedRouteTablesResourceIds: virtualNetworkVwanPropagatedRouteTablesResourceIds
    virtualNetworkVwanPropagatedLabels: virtualNetworkVwanPropagatedLabels
    roleAssignmentEnabled: roleAssignmentEnabled
    roleAssignments: roleAssignments
  }
}

// OUTPUTS

@description('The Subscription ID that has been created or provided.')
output subscriptionId string = (subscriptionAliasEnabled && empty(exisitingSubscriptionId)) ? createSubscription.outputs.subscriptionId : contains(existingSubscriptionIDEmptyCheck, 'No Subscription ID Provided') ? existingSubscriptionIDEmptyCheck : '${exisitingSubscriptionId}'

@description('The Subscription Resource ID that has been created or provided.')
output subscriptionResourceId string = (subscriptionAliasEnabled && empty(exisitingSubscriptionId)) ? createSubscription.outputs.subscriptionResourceId : contains(existingSubscriptionIDEmptyCheck, 'No Subscription ID Provided') ? existingSubscriptionIDEmptyCheck : '/subscriptions/${exisitingSubscriptionId}'
