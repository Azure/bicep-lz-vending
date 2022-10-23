<!-- markdownlint-disable -->
## Telemetry Tracking Using Customer Usage Attribution (PID)
<!-- markdownlint-restore -->

Microsoft can identify the deployments of the Azure Resource Manager and Bicep templates with the deployed Azure resources. Microsoft can correlate these resources used to support the deployments. Microsoft collects this information to provide the best experiences with their products and to operate their business. The telemetry is collected through [customer usage attribution](https://docs.microsoft.com/azure/marketplace/azure-partner-customer-usage-attribution). The data is collected and governed by Microsoft's privacy policies, located at the [trust center](https://www.microsoft.com/trustcenter).

To disable this tracking, we have included a parameter called `disableTelemetry` to every bicep module in this repo with a simple boolean flag. The default value `false` which **does not** disable the telemetry. If you would like to disable this tracking, then simply set this value to `true` and this module will not be included in deployments and **therefore disables** the telemetry tracking.

If you are happy with leaving telemetry tracking enabled, no changes are required. Please do not edit the module name or value of the variable `cuaPid` in any module.

For example, in the managementGroups.bicep file, you will see the following:

```bicep
@description('Set Parameter to True to Opt-out of deployment telemetry')
param disableTelemetry bool = true
```

The default value is `false`, but by changing the parameter value `true` and saving this file, when you deploy this module either via PowerShell, Azure CLI, or as part of a pipeline the module deployment below will be ignored and therefore telemetry will not be tracked.

```bicep
resource moduleTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (!disableTelemetry) {
  name: 'pid-${cuaPid}-${uniqueString(deployment().name, virtualNetworkLocation)}'
  location: virtualNetworkLocation
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}
```

## Module CUA PID Value Mapping

The following are the unique CUA ID's (also known as PIDs) used in the modules:

| Module Name  | CUA PID                                |
| ------------ | -------------------------------------- |
| `main.bicep` | `10d75183-0090-47b2-9c1b-48e3a4a36786` |
