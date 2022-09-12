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

@description('An object of tag key/value pairs to be appended to a subscription. NOTE: Tags will only be overwriten if existing tag exists with same key; values provided here win.')
param subscriptionTags object = {}

@description('Whether to create a virtual network or not.')
param virtualNetworkEnabled bool = false

@maxLength(90)
@description('The name of the resource group to create the virtual network in.')
param virtualNetworkResourceGroupName string = ''

@description('Enables the deployment of a `CanNotDelete` resource locks to the virtual networks resource group.')
param virtualNetworkResourceGroupLockEnabled bool = true

@description('The location of the virtual network. Use region shortnames e.g. uksouth, eastus, etc.')
param virtualNetworkLocation string = deployment().location

@description('The name of the virtual network. The string must consist of a-z, A-Z, 0-9, -, _, and . (period) and be between 2 and 64 characters in length.')
param virtualNetworkName string

@description('The address space of the virtual network, supplied as multiple CIDR blocks, e.g. `["10.0.0.0/16","172.16.0.0/12"]`')
param virtualNetworkAddressSpace array

@description('Whether to enable peering/connection with the supplied hub virtual network or virtual hub.')
param virtualNetworkPeeringEnabled bool = false

@description('The resource ID of the virtual network or virtual wan hub in the hub to which the created virtual network will be peered/connected to via vitrual network peering or a vitrual hub connection.')
param hubNetworkResourceId string = ''

@description('Enables the use of remote gateways in the spefcified hub virtual network. If no gateways exsit in the hub virtual network, set this to false, otherwise peering will fail to create.')
param virtualNetworkUseRemoteGateways bool = true

@description('The resource ID of the virtual hub route table to associate to the virtual hub connection (this virtual network). If left blank/empty default route table will be associated.')
param virtualNetworkVwanAssociatedRouteTableResourceId string = ''

@description('An array of virtual hub route table resource IDs to propogate routes to. If left blank/empty default route table will be propogated to only.')
param virtualNetworkVwanPropagatedRouteTablesResourceIds array = []

@description('An array of virtual hub route table labels to propogate routes to. If left blank/empty default label will be propogated to only.')
param virtualNetworkVwanPropagatedLabels array = []

@description('Whether to create role assignments or not. If true, supply the array of role assignment objects in the parameter called `roleAassignments`.')
param roleAssignmentEnabled bool = false

@description('Supply an array of objects containing the details of the role assignments to create.')
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
