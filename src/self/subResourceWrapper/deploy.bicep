targetScope = 'managementGroup'

// PARAMETERS

@maxLength(36)
param subscriptionId string

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
param virtualNetworkResourceGroupName string

@description('Enables the deployment of a `CanNotDelete` resource locks to the virtual networks resource group.')
param virtualNetworkResourceGroupLockEnabled bool = true

@description('The location of the virtual network. Use region shortnames e.g. uksouth, eastus, etc.')
param virtualNetworkLocation string = deployment().location

@maxLength(64)
@description('The name of the virtual network. The string must consist of a-z, A-Z, 0-9, -, _, and . (period) and be between 2 and 64 characters in length.')
param virtualNetworkName string

@description('The address space of the virtual network, supplied as multiple CIDR blocks, e.g. `["10.0.0.0/16","172.16.0.0/12"]`')
param virtualNetworkAddressSpace array

@description('Whether to enable peering/connection with the supplied hub virtual network or virtual hub.')
param virtualNetworkPeeringEnabled bool = false

@description('The resource ID of the virtual network or virtual wan hub in the hub to which the created virtual network will be peered/connected to via vitrual network peering or a vitrual hub connection.')
param hubNetworkResourceId string = ''

@description('Enables the use of remote gateways in the spefcified hub virtual network. If no gateways exsit in the hub virtual network, set this to `false`, otherwise peering will fail to create. Set this to `false` for virtual wan hub connections.')
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
param roleAssignments array = [
  {
    principalId: '00000000-0000-0000-0000-000000000000'
    definition: 'Contributor'
    relativeScope: ''
  }
  {
    principalId: '00000000-0000-0000-0000-000000000000'
    definition: 'Contributor'
    relativeScope: '/resourceGroups/rsg-networking-001'
  }
]

// VARIABLES

// Deployment name variables
// LIMITS: Tenant = 64, Management Group = 64, Subscription = 64, Resource Group = 64
var deploymentNames = {
  moveSubscriptionToManagementGroup: take('lz-vend-move-sub-${uniqueString(subscriptionId, subscriptionManagementGroupId, deployment().name)}', 64)
  tagSubscription: take('lz-vend-tag-sub-${uniqueString(subscriptionId, deployment().name)}', 64)
  createResourceGroupForLzNetworking: take('lz-vend-rsg-create-${uniqueString(subscriptionId, virtualNetworkResourceGroupName, virtualNetworkLocation, deployment().name)}', 64)
  createLzVnet: take('lz-vend-vnet-create-${uniqueString(subscriptionId, virtualNetworkResourceGroupName, virtualNetworkLocation, virtualNetworkName, deployment().name)}', 64)
  createLzVirtualWanConnection: take('lz-vend-vhc-create-${uniqueString(subscriptionId, virtualNetworkResourceGroupName, virtualNetworkLocation, virtualNetworkName, virtualHubResourceIdChecked, deployment().name)}', 64)
  createLzRoleAssignments: take('lz-vend-rbac-create-${uniqueString(subscriptionId, deployment().name)}', 64)
}

// Check hubNetworkResourceId to see if it's a virtual WAN connection instead of normal virtual network peering
var virtualHubResourceIdChecked = (!empty(hubNetworkResourceId) && contains(hubNetworkResourceId, '/providers/Microsoft.Network/virtualHubs/') ? hubNetworkResourceId : '')
var hubVirtualNetworkResourceIdChecked = (!empty(hubNetworkResourceId) && contains(hubNetworkResourceId, '/providers/Microsoft.Network/virtualNetworks/') ? hubNetworkResourceId : '')

// Virtual WAN data
var virtualWanHubName = split(virtualHubResourceIdChecked, '/')[8]
var virtualWanHubSubscriptionId = split(virtualHubResourceIdChecked, '/')[2]
var virtualWanHubResourceGroupName = split(virtualHubResourceIdChecked, '/')[4]
var virtualWanHubConnectionName = 'vhc-${guid(virtualHubResourceIdChecked, virtualNetworkName, virtualNetworkResourceGroupName, virtualNetworkLocation)}'
var virtualWanHubConnectionAssociatedRouteTable = !empty(virtualNetworkVwanAssociatedRouteTableResourceId) ? virtualNetworkVwanAssociatedRouteTableResourceId : '${virtualHubResourceIdChecked}/hubRouteTables/defaultRouteTable'
var virutalWanHubDefaultRouteTableId = {
  id: '${virtualHubResourceIdChecked}/hubRouteTables/defaultRouteTable'
}
var virtualWanHubConnectionPropogatedRouteTables = !empty(virtualNetworkVwanPropagatedRouteTablesResourceIds) ? virtualNetworkVwanPropagatedRouteTablesResourceIds : array(virutalWanHubDefaultRouteTableId)
var virtualWanHubConnectionPropogatedLabels = !empty(virtualNetworkVwanPropagatedLabels) ? virtualNetworkVwanPropagatedLabels : [ 'default' ]

// RESOURCES & MODULES

module moveSubscriptionToManagementGroup '../Microsoft.Management/managementGroups/subscriptions/deploy.bicep' = if (subscriptionManagementGroupAssociationEnabled && !empty(subscriptionManagementGroupId)) {
  scope: managementGroup(subscriptionManagementGroupId)
  name: deploymentNames.moveSubscriptionToManagementGroup
  params: {
    subscriptionManagementGroupId: subscriptionManagementGroupId
    subscriptionId: subscriptionId
  }
}

module tagSubscription '../../carml/v0.6.0/Microsoft.Resources/tags/deploy.bicep' = if (!empty(subscriptionTags)) {
  scope: subscription(subscriptionId)
  name: deploymentNames.tagSubscription
  params: {
    subscriptionId: subscriptionId
    location: virtualNetworkLocation
    onlyUpdate: true
    tags: subscriptionTags
  }
}

module createResourceGroupForLzNetworking '../../carml/v0.6.0/Microsoft.Resources/resourceGroups/deploy.bicep' = if (virtualNetworkEnabled) {
  scope: subscription(subscriptionId)
  name: deploymentNames.createResourceGroupForLzNetworking
  params: {
    name: virtualNetworkResourceGroupName
    location: virtualNetworkLocation
    lock: virtualNetworkResourceGroupLockEnabled ? 'CanNotDelete' : ''
  }
}

module createLzVnet '../../carml/v0.6.0/Microsoft.Network/virtualNetworks/deploy.bicep' = if (virtualNetworkEnabled) {
  dependsOn: [
    createResourceGroupForLzNetworking
  ]
  scope: resourceGroup(subscriptionId, virtualNetworkResourceGroupName)
  name: deploymentNames.createLzVnet
  params: {
    name: virtualNetworkName
    location: virtualNetworkLocation
    addressPrefixes: virtualNetworkAddressSpace
    virtualNetworkPeerings: (virtualNetworkPeeringEnabled && !empty(hubVirtualNetworkResourceIdChecked)) ? [
      {
        allowForwardedTraffic: true
        allowVirtualNetworkAccess: true
        allowGatewayTransit: false
        useRemoteGateways: virtualNetworkUseRemoteGateways
        remotePeeringEnabled: virtualNetworkPeeringEnabled
        remoteVirtualNetworkId: hubVirtualNetworkResourceIdChecked
        remotePeeringAllowForwardedTraffic: true
        remotePeeringAllowVirtualNetworkAccess: true
        remotePeeringAllowGatewayTransit: true
        remotePeeringUseRemoteGateways: false
      }
    ] : []
  }
}

module createLzVirtualWanConnection '../../carml/v0.6.0/Microsoft.Network/virtualHubs/hubVirtualNetworkConnections/deploy.bicep' = if (virtualNetworkEnabled && virtualNetworkPeeringEnabled && !empty(virtualHubResourceIdChecked)) {
  dependsOn: [
    createResourceGroupForLzNetworking
  ]
  scope: resourceGroup(virtualWanHubSubscriptionId, virtualWanHubResourceGroupName)
  name: deploymentNames.createLzVirtualWanConnection
  params: {
    name: virtualWanHubConnectionName
    virtualHubName: virtualWanHubName
    remoteVirtualNetworkId: createLzVnet.outputs.resourceId
    routingConfiguration: {
      associatedRouteTable: {
        id: virtualWanHubConnectionAssociatedRouteTable
      }
      propagatedRouteTables: {
        ids: virtualWanHubConnectionPropogatedRouteTables
        labels: virtualWanHubConnectionPropogatedLabels
      }
    }
  }
}

module createLzRoleAssignments '../../carml/v0.6.0/Microsoft.Authorization/roleAssignments/deploy.bicep' = [for assignment in roleAssignments: if (roleAssignmentEnabled && !empty(roleAssignments)) {
  dependsOn: [
    createResourceGroupForLzNetworking
  ]
  name: take('${deploymentNames.createLzRoleAssignments}-${uniqueString(assignment.principalId, assignment.definition, assignment.relativeScope)}', 64)
  params: {
    location: virtualNetworkLocation
    principalId: assignment.principalId
    roleDefinitionIdOrName: assignment.definition
    subscriptionId: subscriptionId
    resourceGroupName: (contains(assignment.relativeScope, '/resourceGroups/') ? assignment.relativeScope : '')
    
  }
}]

// OUTPUTS
