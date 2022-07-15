targetScope = 'managementGroup'

// PARAMETERS

@maxLength(36)
param subscriptionId string

param subscriptionTags object = {}

param virtualNetworkTags object = {}

param virtualNetworkResourceGroupName string

param virtualNetworkEnabled bool

// param virtualNetworkAddressSpace array

param virtualNetworkLocation string

// param virtualNetworkPeeringEnabled bool

// param hubNetworkResourceId string

// VARIABLES

// Deployment name variables
// LIMITS: Tenant = 64, Management Group = 64, Subscription = 64, Resource Group = 64
var deploymentNames = {
  createResourceGroupForLzNetworking: take('lz-vend-rsg-create-${uniqueString(subscriptionId, virtualNetworkResourceGroupName, virtualNetworkLocation)}', 64)
  tagSubscription: take('lz-vend-tag-sub-${uniqueString(subscriptionId)}', 64)
}

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
    tags: virtualNetworkTags
  }
}

// OUTPUTS
