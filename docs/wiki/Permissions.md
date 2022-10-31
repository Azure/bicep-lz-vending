<!-- markdownlint-disable MD041 -->
## Permissions required

This module can create and use the following resources during its deployment:

- `Microsoft.Subscription/aliases`
- `Microsoft.Management/managementGroups/subscriptions`
- `Microsoft.Resources/deployments` at the following scopes:
  - Tenant - `/`
  - Management Group - `Microsoft.Management/managementGroups`
  - Subscription
  - Resource Group
- `Microsoft.Resources/tags` at the following scopes:
  - Subscription
  - Resource Group
  - Resource
- `Microsoft.Authorization/locks` at the following scopes:
  - Resource Group
- `Microsoft.Authorization/roleAssignments` at the following scopes:
  - Subscription
  - Resource Group
  - Resources
- `Microsoft.Resources/resourceGroups`
- `Microsoft.Network/virtualNetworks`
- `Microsoft.Network/virtualNetworks/virtualNetworkPeerings`
- `Microsoft.Network/virtualHubs/hubVirtualNetworkConnections`

The identity used must have permissions to:

- **Create Subscriptions using the `Microsoft.Subscription/aliases` resource**
  - See documentation on this resource here in: [Create Azure subscriptions programmatically](https://learn.microsoft.com/azure/cost-management-billing/manage/programmatically-create-subscription)
    - See documentation for instructions on how to grant/assign EA roles to SPNs: [Assign roles to Azure Enterprise Agreement service principal name](https://learn.microsoft.com/azure/cost-management-billing/manage/assign-roles-azure-service-principals)
- **Manage the Subscription's Management Group association using the `Microsoft.Management/managementGroups/subscriptions` resource**
  - See documentation on the required permissions here in: [What are Azure management groups? - Moving management groups and subscriptions](https://learn.microsoft.com/azure/governance/management-groups/overview#moving-management-groups-and-subscriptions)
    - **Note:** The identity that creates the Subscription will have the RBAC `Owner` role assigned to the Subscription by default. If you are using an existing Subscription with this module, you must ensure the identity you are using with this module has `Owner` permissions upon that existing Subscription prior to using the module with it.
- **Create the Subscription core resources (Resource Group, Virtual Network, Virtual Network Peerings, Resource Locks, Role Assignments)**
  - The default assigned RBAC `Owner` role on the Subscription for the identity creating it will be sufficient to create the resources in the Subscription.
    - **Note:** If you are using an existing Subscription with this module, you must ensure the identity you are using with this module has `Owner` permissions upon that existing Subscription prior to using the module with it.
  - **Create the "hub side" of the Virtual Network Peerings/Virtual WAN Hub Connections**
    - To create the Virtual Network Peerings or Virtual Hub Connections to the Hub Virtual Networks or Virtual WAN Hub, that is in a different Subscription, you must ensure the identity deploying this module has the `Network Contributor` RBAC role assigned upon the Hub Virtual Network or Virtual WAN Hub resources, Resource Group, or Subscription.
