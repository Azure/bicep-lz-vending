# Bicep landing zone vending module for Azure

## Overview

The landing zone Bicep modules are designed to accelerate deployment of the individual landing zones (aka Subscriptions) within an Azure AD Tenant.

The modules are designed to be instantiated many times, once for each desired landing zone.

This is currently split logically into the following capabilities:

- Subscription creation and management group placement
- Hub & spoke networking
- Virtual WAN networking
- Role assignments

> We would like feedback on what's missing in the module. Please raise an [issue](https://github.com/Azure/bicep-lz-vending/issues) if you have any suggestions.

## Notes

Please see the content in the [wiki](https://github.com/Azure/bicep-lz-vending/wiki) for more detailed information.

## Example

Below is an example showing how to use this module.

> For more examples please see the [wiki](https://github.com/Azure/bicep-lz-vending/wiki) and if you cannot find an example you are looking for please [raise an issue](https://github.com/Azure/bicep-lz-vending/issues/new/choose) on the repo 👍

```bicep
TBC
```

test ` ` 

## Parameters

Parameters for the [`main.bicep`](main.bicep) module can be found [here: `main.bicep.parameters.md`](main.bicep.parameters.md).

> These docs are automatically generated using [PSDocs.Azure](https://azure.github.io/PSDocs.Azure) from the Bicep module file itself and [this GitHub Action](.github/workflows/psdocs-azure.yml)

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

## Trademarks

This project may contain trademarks or logos for projects, products, or services.
Authorized use of Microsoft trademarks or logos is subject to and must follow
[Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/legal/intellectualproperty/trademarks/usage/general).
Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship.
Any use of third-party trademarks or logos are subject to those third-party's policies.
