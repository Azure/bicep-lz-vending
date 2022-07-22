targetScope = 'managementGroup'

// PARAMETERS

@maxLength(36)
param subscriptionId string

@description('An object of tag key/value pairs to be appended to a subscription. NOTE: Tags will only be overwriten if existing tag exists with same key; values provided here win.')
param subscriptionTags object = {}

@description('Whether to create a virtual network or not.')
param virtualNetworkEnabled bool = false

@maxLength(90)
@description('The name of the resource group to create the virtual network in.')
param virtualNetworkResourceGroupName string

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

@description('Enables the use of remote gateways in the spefcified hub virtual network. If no gateways exsit in the hub virtual network, set this to false, otherwise peering will fail to create.')
param virtualNetworkUseRemoteGateways bool = true

// VARIABLES

// Deployment name variables
// LIMITS: Tenant = 64, Management Group = 64, Subscription = 64, Resource Group = 64
var deploymentNames = {
  createResourceGroupForLzNetworking: take('lz-vend-rsg-create-${uniqueString(subscriptionId, virtualNetworkResourceGroupName, virtualNetworkLocation, deployment().name)}', 64)
  tagSubscription: take('lz-vend-tag-sub-${uniqueString(subscriptionId, deployment().name)}', 64)
  createLzVnet: take('lz-vend-vnet-create-${uniqueString(subscriptionId, virtualNetworkResourceGroupName, virtualNetworkLocation, virtualNetworkName, deployment().name)}', 64)
  // createVirtualWanConnection: take('lz-vend-vhc-create-${uniqueString(subscriptionId, virtualNetworkResourceGroupName, virtualNetworkLocation, virtualNetworkName, virtualHubResourceIdChecked, deployment().name)}', 64)
}

// Check hubNetworkResourceId to see if it's a virtual WAN connection instead of normal virtual network peering
var virtualHubResourceIdChecked = (!empty(hubNetworkResourceId) && contains(hubNetworkResourceId, '/providers/Microsoft.Network/virtualHubs/') ? hubNetworkResourceId : '')
var hubVirtualNetworkResourceIdChecked = (!empty(hubNetworkResourceId) && contains(hubNetworkResourceId, '/providers/Microsoft.Network/virtualNetworks/') ? hubNetworkResourceId : '')

// Virtual WAN data
// var virtualWanHubName = split(virtualHubResourceIdChecked, '/')[8]
// var virtualWanHubSubscriptionId = split(virtualHubResourceIdChecked, '/')[2]
// var virtualWanHubConnectionName = 'vhc-${guid(virtualHubResourceIdChecked, virtualNetworkName, virtualNetworkResourceGroupName, virtualNetworkLocation)}'


// RESOURCES & MODULES

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

// module createVirtualWanConnection '../../carml/v0.6.0/Microsoft.Network/virtualHubs/hubVirtualNetworkConnections/deploy.bicep' = if (virtualNetworkEnabled && !empty(virtualHubResourceIdChecked) ) {
//   dependsOn: [
//     createResourceGroupForLzNetworking
//   ]
//   scope: resourceGroup(subscriptionId, virtualNetworkResourceGroupName)
//   name: deploymentNames.createVirtualWanConnection
//   params: {
//     name: virtualWanHubConnectionName
//     virtualHubName: virtualWanHubName
//     remoteVirtualNetworkId: createLzVnet.outputs.resourceId
//   }
// }

// OUTPUTS
