@description('Specifies the location for resources.')
param location string = 'uksouth'

targetScope = 'managementGroup'


// REPRO - Create new sub etc.
// module repro1 'main.bicep' = {
//   name: 'sub-bicep-repro-1'
//   params: {
//     subscriptionAliasEnabled: true
//     subscriptionBillingScope: '/providers/Microsoft.Billing/billingAccounts/7690848/enrollmentAccounts/318926'
//     subscriptionAliasName: 'sub-test-bicep-repro-1'
//     subscriptionDisplayName: 'sub-test-bicep-repro-1'
//     subscriptionTags: {
//       example: 'true'
//     }
//     subscriptionWorkload: 'Production'
//     subscriptionManagementGroupAssociationEnabled: true
//     subscriptionManagementGroupId: 'test-lz-vend'
//     disableTelemetry: false
//     virtualNetworkEnabled: false
//   }
// }

// REPRO - Use existing sub
module repro2 'main.bicep' = {
  name: 'sub-bicep-repro-2'
  params: {
    subscriptionAliasEnabled: false
    existingSubscriptionId: '91ed4b24-f078-425c-a7af-bbe22bd7f81d'
    subscriptionTags: {
      example: 'true'
    }
    subscriptionManagementGroupAssociationEnabled: true
    subscriptionManagementGroupId: 'test-lz-vend'
    disableTelemetry: false
    virtualNetworkEnabled: false
  }
}
