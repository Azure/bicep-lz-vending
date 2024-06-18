# Bicep landing zone vending module for Azure

[![Average time to resolve an issue](http://isitmaintained.com/badge/resolution/azure/bicep-lz-vending.svg)](http://isitmaintained.com/project/azure/bicep-lz-vending "Average time to resolve an issue")
[![Percentage of issues still open](http://isitmaintained.com/badge/open/azure/bicep-lz-vending.svg)](http://isitmaintained.com/project/azure/bicep-lz-vending "Percentage of issues still open")
[![OpenSSF Scorecard](https://api.scorecard.dev/projects/github.com/Azure/bicep-lz-vending/badge)](https://scorecard.dev/viewer/?uri=github.com/Azure/bicep-lz-vending)

_____________________________________________________________________________________________________________________________________

## ⚠️⚠️ Repository archival notice ⚠️⚠️

We would like to inform you that this repository has been **archived** and the Bicep landing zone vending module for Azure now has a new home in the [Bicep public registry](https://aka.ms/lz-vending/bicep) and is now a pattern module in the [Azure Verified Modules](https://aka.ms/avm) initiative.

### What does this mean?

- This repository is now in a **read-only** state.
- No further issues, pull requests, or updates will be maintained on this repository.
- All future releases, fixes and improvements will be managed in the new AVM pattern module hosted on the [Bicep public registry](https://aka.ms/lz-vending/bicep).
- We will continue to leverage the [Wiki](https://github.com/azure/bicep-lz-vending/wiki) in this repository as the module's additional documentation and guidance location.

### Why was this done?

We are converting this module to be an [Azure Verified pattern module](https://aka.ms/avm) to better align with the [Azure Verified Modules](https://azure.github.io/Azure-Verified-Modules/concepts/what-why-how/) initiative. This will help us align with the Well-architected framework guidance, have improved [module support](https://azure.github.io/Azure-Verified-Modules/help-support/module-support/) and provide you with a consistent experience consuming [AVM Bicep modules](https://azure.github.io/Azure-Verified-Modules/indexes/bicep/).

📒 If you are not familiar with [Azure Verified Modules](https://aka.ms/avm), you can watch the following Youtube videos for a quick overview:

- [An Introduction to Azure Verified Modules (AVM) by the Customer Architecture & Engineering team](https://youtu.be/JbIMrJKW5N0?si=4v69hlyBbINufHEO) 📽️🎬🎞️
- [Azure Verified Modules Overview by John Savill](https://youtu.be/3FeIFHaJOtg?si=ZDXJ3EPwT9Xlzq2P) 📽️🎬🎞️

### If I'm already using the Bicep Subscription vending module from the Bicep public registry, what do I need to change?

We tried as much as possible to have a smooth transition path with minimal breaking changes. To switch to the new module:

- Review the documentation for the [new AVM module](https://aka.ms/lz-vending/bicep).
- Change the module reference in your code to reference `br/public:avm/ptn/lz/sub-vending:x.x.x` instead of `br/public:lz/sub-vending:x.x.x`
- If you have a preference on sharing deployment elemetry for this module, the parameter `disableTelemetry` has been changed to `enableTelemetry`. This change is due to AVM modules mandate the use of this parameter.

> **NOTE:** After the migration to Azure Verified Modules, version `1.5.2` of the Subscription Vending module is now `0.1.0` in the [Bicep public registry](https://aka.ms/lz-vending/bicep).

### Feedback

For any issues, suggestions or feedback for this module, please open an issue on the [Bicep public registry](https://github.com/Azure/bicep-registry-modules/issues).

Thank you for your understanding and continued support.

__________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________;

## Overview

> ℹ️ This module requires the usage of Bicep version `v0.11.1` or later. For details on installing/upgrading Bicep see: [Install Bicep tools](https://learn.microsoft.com/azure/azure-resource-manager/bicep/install) ℹ️
>
> ℹ️ This module is also available on the Bicep Module Registry [here](https://github.com/Azure/bicep-registry-modules/tree/main/avm/ptn/lz/sub-vending). Examples also included in our [wiki examples](https://github.com/Azure/bicep-lz-vending/wiki/examples). ℹ️

The landing zone Bicep modules are designed to accelerate deployment of the individual landing zones (aka Subscriptions) within an Microsoft Entra Tenant.

> See the different types of landing zones in the Azure Landing Zones documentation here: [What is an Azure landing zone? - Platform vs. application landing zones](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/#platform-vs-application-landing-zones)

The modules are designed to be instantiated many times, once for each desired landing zone.

This is currently split logically into the following capabilities:

- Subscription creation and management group placement
- Networking - deploy a Virtual Network with, optional:
  - Hub & spoke connectivity (peering to a hub Virtual Network)
  - Virtual WAN connectivity (peering to a Virtual Hub via a Virtual Hub Connection)
    - Including support for connections to Virtual WAN Hubs with Routing Intent configured
  - Link to existing DDoS Network Protection Plan
  - Specify Custom DNS Servers
- Role assignments
- Tags
- Resource providers and resource providers features registration

> When creating Virtual Network peerings, be aware of the [limit of peerings per Virtual Network.](https://learn.microsoft.com/azure/azure-resource-manager/management/azure-subscription-service-limits?toc=%2Fazure%2Fvirtual-network%2Ftoc.json#azure-resource-manager-virtual-networking-limits)

We would like feedback on what's missing in the module. Please raise an [issue](https://github.com/Azure/bicep-lz-vending/issues) if you have any suggestions.

## Community Events/Recordings

- [Bicep Community Call - November 2022](https://youtu.be/hu0PgCamxt0?t=1038) 📽️🎬🎞️

## Change Log/Releases

Please see this repositories [GitHub releases](https://github.com/Azure/bicep-lz-vending/releases) for information on the latest changes and releases.

## Wiki

Please see the content in the [wiki](https://github.com/Azure/bicep-lz-vending/wiki) for more detailed information about the module and various other pieces of documentation.

## Known Issues

Please see the [Known Issues in the wiki](https://github.com/Azure/bicep-lz-vending/wiki/knownissues).

## Parameters for module `main.bicep`

**Parameters documented here: [`main.bicep.parameters.md`](main.bicep.parameters.md).**

Details on each of the parameters, including examples and an [example parameter file](main.bicep.parameters.md#parameter-file) (this is not a valid parameter file as all parameters contain values, so you must remove the un-required parameters or set them back to their default value, as documented), for the [`main.bicep`](main.bicep) module can be found [here: `main.bicep.parameters.md`](main.bicep.parameters.md).

> These docs are automatically generated using [PSDocs.Azure](https://azure.github.io/PSDocs.Azure) from the Bicep module file itself and [this GitHub Action](.github/workflows/update-bicep-module-docs.yml) as part of PRs that amend this Bicep module.

## Consumer Guide

We have a [Consumer Guide](https://github.com/azure/bicep-lz-vending/wiki/consumerguide) available for guidance on how to consume this module.

## Example

> For more examples please see the [wiki](https://github.com/Azure/bicep-lz-vending/wiki) and if you cannot find an example you are looking for please [raise an issue](https://github.com/Azure/bicep-lz-vending/issues/new/choose) on the repo 👍

Below is an example showing how to use this module.

Most commonly this module will be deployed using [PowerShell](https://learn.microsoft.com/powershell/scripting/overview), with the [Azure Az Module](https://learn.microsoft.com/powershell/azure/what-is-azure-powershell), with a supporting `.json` parameters file, one per landing zone to create/vend. Or the same approach but using the [Azure CLI](https://learn.microsoft.com/cli/azure/what-is-azure-cli).

> **IMPORTANT:** The below example requires you have cloned/downloaded the entire repo and have it available at run-time on the machine running the below commands. It is also expected you are in the root of the cloned/extracted repository; otherwise paths will need to be changed in the below example.

### PowerShell Example

```powershell
$inputObject = @{
  DeploymentName        = 'lz-vend-{0}' -f (-join (Get-Date -Format 'yyyyMMddTHHMMssffffZ')[0..63])
  ManagementGroupId     = 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx' # Set this to the Management Group ID you wish to target the deployment against. NOTE: This isn't the Management Group that the Subscription will be moved to, that is specified via the parameters.
  Location              = 'uksouth' # Set this to the Azure Region you wish the deployment to be targeted against. NOTE: This isn't the Region that the Subscription's resources will be deployed to, that is specified via the parameters.
  TemplateParameterFile = './landingZones/lz1.parameters.json' # This would be changed to the specific file per landing zone.
  TemplateFile          = "./main.bicep" # Set this to the path where you have checked out this repo to.
}

New-AzManagementGroupDeployment @inputObject
```

### Azure CLI Example

```bash
dateYMD=$(date +%Y%m%dT%H%M%S%NZ)
DEPLOYMENTNAME="lz-vend-${dateYMD}"
MANAGEMENTGROUPID="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" # Set this to the Management Group ID you wish to target the deployment against. NOTE: This isn't the Management Group that the Subscription will be moved to, that is specified via the parameters.
LOCATION="uksouth" # Set this to the Azure Region you wish the deployment to be targeted against. NOTE: This isn't the Region that the Subscription's resources will be deployed to, that is specified via the parameters.
TEMPLATEPARAMETERFILE="@/landingZones/lz1.parameters.json" # This would be changed to the specific file per landing zone.
TEMPLATEFILE="/main.bicep" # Set this to the path where you have checked out this repo to.

az deployment mg create --name ${DEPLOYMENTNAME:0:63} --parameters $TEMPLATEPARAMETERFILE --location $LOCATION --management-group-id $MANAGEMENTGROUPID --template-file $TEMPLATEFILE
```

## Contributing

This project welcomes contributions and suggestions.
Most contributions require you to agree to a Contributor License Agreement (CLA)
declaring that you have the right to, and actually do, grant us the rights to use your contribution.
For details, visit [https://cla.opensource.microsoft.com](https://cla.opensource.microsoft.com).

When you submit a pull request, a CLA bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., status check, comment).
Simply follow the instructions provided by the bot.
You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

> Details on contributing to this repo can be found [here in the wiki](https://github.com/azure/bicep-lz-vending/wiki/contributing) 👍

## Telemetry

When you deploy the Bicep landing zone vending module for Azure module, Microsoft can identify the installation of said module/s with the deployed Azure resources. Microsoft can correlate these resources used to support the software. Microsoft collects this information to provide the best experiences with their products and to operate their business. The telemetry is collected through customer usage attribution. The data is collected and governed by [Microsoft's privacy policies](https://www.microsoft.com/trustcenter).

If you don't wish to send usage data to Microsoft, details on how to turn it off can be found [here.](https://github.com/azure/bicep-lz-vending/wiki/telemetry).

## Trademarks

This project may contain trademarks or logos for projects, products, or services.
Authorized use of Microsoft trademarks or logos is subject to and must follow
[Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/legal/intellectualproperty/trademarks/usage/general).
Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship.
Any use of third-party trademarks or logos are subject to those third-party's policies.
