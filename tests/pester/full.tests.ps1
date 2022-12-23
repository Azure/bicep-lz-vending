[CmdletBinding()]
param (
  [Parameter(Mandatory)]
  [string]
  $prNumber,

  [Parameter(Mandatory)]
  [string]
  $subId,

  [Parameter(Mandatory)]
  [string]
  $location
)

Describe "Bicep Landing Zone (Sub) Vending Tests" {

  BeforeAll {
    Update-AzConfig -DisplayBreakingChangeWarning $false
    Select-AzSubscription -subscriptionId $subId
  }

  Context "Subscription Tests" {
    BeforeAll {
      $sub = Get-AzSubscription -SubscriptionId $subId -ErrorAction SilentlyContinue
    }

    It "Should have a Subscription with the correct name" {
      $sub.Name | Should -Be "sub-blzv-tests-pr-$prNumber"
    }

    It "Should have a Subscription that is enabled" {
      $sub.State | Should -Be "Enabled"
    }

    It "Should have a Subscription with a tag key of 'prNumber'" {
      $sub.Tags.Keys | Should -Contain "prNumber"
    }

    It "Should have a Subscription with a tag key of 'prNumber' with a value of '$prNumber'" {
      $sub.Tags.prNumber | Should -Be $prNumber
    }

    It "Should have a Subscription that is a child of the Management Group with the ID of 'bicep-lz-vending-automation-child'" {
      $mgAssociation = Get-AzManagementGroupSubscription -SubscriptionId $subId -GroupId "bicep-lz-vending-automation-child" -ErrorAction SilentlyContinue
      $mgAssociation.Id | Should -Be "/providers/Microsoft.Management/managementGroups/bicep-lz-vending-automation-child/subscriptions/$subId"
    }
  }

  Context "Hub Spoke - Resource Group Tests" {
    BeforeAll {
      $rsg = Get-AzResourceGroup -Name "rsg-$location-net-hs-pr-$prNumber" -ErrorAction SilentlyContinue
    }

    It "Should have a Resource Group with the correct name" {
      $rsg.ResourceGroupName | Should -Be "rsg-$location-net-hs-pr-$prNumber"
    }

    It "Should have a Resource Group with the correct location" {
      $rsg.Location | Should -Be $location
    }
  }

  Context "Virtual WAN - Resource Group Tests" {
    BeforeAll {
      $rsg = Get-AzResourceGroup -Name "rsg-$location-net-vwan-pr-$prNumber" -ErrorAction SilentlyContinue
    }

    It "Should have a Resource Group with the correct name" {
      $rsg.ResourceGroupName | Should -Be "rsg-$location-net-vwan-pr-$prNumber"
    }

    It "Should have a Resource Group with the correct location" {
      $rsg.Location | Should -Be $location
    }
  }

  Context "Networking - Hub Spoke Tests" {
    BeforeAll {
      $vnetHs = Get-AzVirtualNetwork -ResourceGroupName "rsg-$location-net-hs-pr-$prNumber" -Name "vnet-$location-hs-pr-$prNumber" -ErrorAction SilentlyContinue
    }

    It "Should have a Virtual Network in the correct Resource Group" {
      $vnetHs.ResourceGroupName | Should -Be "rsg-$location-net-hs-pr-$prNumber"
    }

    It "Should have a Virtual Network with the correct name" {
      $vnetHs.Name | Should -Be "vnet-$location-hs-pr-$prNumber"
    }

    It "Should have a Virtual Network with the correct location" {
      $vnetHs.Location | Should -Be $location
    }

    It "Should have a Virtual Network with the correct address space" {
      $vnetHs.AddressSpace.AddressPrefixes | Should -Be "10.100.0.0/16"
    }

    It "Should have a Virtual Network with DDoS protection disabled" {
      $vnetHs.EnableDdosProtection | Should -Be $false
      $vnetHs.ddosProtectionPlan | Should -BeNullOrEmpty
    }

    It "Should have a Virtual Network with a single Virtual Network Peer" {
      $vnetHs.VirtualNetworkPeerings.Count | Should -Be 1
    }

    It "Should have a Virtual Network with a Virtual Network Peering to the Hub Virtual Network called 'vnet-uksouth-hub-blzv'" {
      $vnetHs.VirtualNetworkPeerings[0].RemoteVirtualNetwork.id | Should -Be "/subscriptions/e4e7395f-dc45-411e-b425-95f75e470e16/resourceGroups/rsg-blzv-perm-hubs-001/providers/Microsoft.Network/virtualNetworks/vnet-uksouth-hub-blzv"
    }

    It "Should have a Virtual Network with a Virtual Network Peering to the Hub Virtual Network called 'vnet-uksouth-hub-blzv' that is in the Connected state and FullyInSync" {
      $vnetHs.VirtualNetworkPeerings[0].RemoteVirtualNetwork.id | Should -Be "/subscriptions/e4e7395f-dc45-411e-b425-95f75e470e16/resourceGroups/rsg-blzv-perm-hubs-001/providers/Microsoft.Network/virtualNetworks/vnet-uksouth-hub-blzv"
      $vnetHs.VirtualNetworkPeerings[0].PeeringState | Should -Be "Connected"
      $vnetHs.VirtualNetworkPeerings[0].PeeringSyncLevel | Should -Be "FullyInSync"
    }

    It "Should have a Virtual Network with a Virtual Network Peering to the Hub Virtual Network called 'vnet-uksouth-hub-blzv' that has AllowForwardedTraffic set to $true" {
      $vnetHs.VirtualNetworkPeerings[0].RemoteVirtualNetwork.id | Should -Be "/subscriptions/e4e7395f-dc45-411e-b425-95f75e470e16/resourceGroups/rsg-blzv-perm-hubs-001/providers/Microsoft.Network/virtualNetworks/vnet-uksouth-hub-blzv"
      $vnetHs.VirtualNetworkPeerings[0].AllowForwardedTraffic | Should -Be $true
    }

    It "Should have a Virtual Network with a Virtual Network Peering to the Hub Virtual Network called 'vnet-uksouth-hub-blzv' that has AllowVirtualNetworkAccess set to $true" {
      $vnetHs.VirtualNetworkPeerings[0].RemoteVirtualNetwork.id | Should -Be "/subscriptions/e4e7395f-dc45-411e-b425-95f75e470e16/resourceGroups/rsg-blzv-perm-hubs-001/providers/Microsoft.Network/virtualNetworks/vnet-uksouth-hub-blzv"
      $vnetHs.VirtualNetworkPeerings[0].AllowVirtualNetworkAccess | Should -Be $true
    }

    It "Should have a Virtual Network with a Virtual Network Peering to the Hub Virtual Network called 'vnet-uksouth-hub-blzv' that has AllowGatewayTransit set to $false" {
      $vnetHs.VirtualNetworkPeerings[0].RemoteVirtualNetwork.id | Should -Be "/subscriptions/e4e7395f-dc45-411e-b425-95f75e470e16/resourceGroups/rsg-blzv-perm-hubs-001/providers/Microsoft.Network/virtualNetworks/vnet-uksouth-hub-blzv"
      $vnetHs.VirtualNetworkPeerings[0].AllowGatewayTransit | Should -Be $false
    }
  }
}
