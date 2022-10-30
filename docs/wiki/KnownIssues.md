<!-- markdownlint-disable -->
## Known Issues
<!-- markdownlint-restore -->

This module does have some known issues that are primarily issues that are outside of the control of this module and our platform behaviours or limitations, please see below details on the known issues.

### Blank or empty Subnets are removed when re-deploying this module on a Subscription and associated Virtual Network that it previously provisioned

This unfortunately is not an issue with this module, but instead a known behaviour of the Azure platform and the Network RP (Resource Provider) as detailed in the following issue [#2786 Create VNET without destroying all subnets `Azure/azure-quickstart-templates`](https://github.com/Azure/azure-quickstart-templates/issues/2786). There is also a warning about this behaviour [documented here in the ARM docs](https://learn.microsoft.com/azure/azure-resource-manager/templates/deployment-modes#incremental-mode).

#### What should you do?

This scenario whilst painful is commonly not ran into as once the Subscription and associated Virtual Network is initially created it is not then again re-deployed over so therefore this issue is never experienced.

However, if you do run into this issue with this module then please [raise an issue](https://github.com/Azure/bicep-lz-vending/issues/new/choose) and mention the upstream issue [#2786 Create VNET without destroying all subnets `Azure/azure-quickstart-templates`](https://github.com/Azure/azure-quickstart-templates/issues/2786) to emphasise the importance of resolving this long-running painful behaviour for customers in the Network RP.

We are working closely with the ARM & Networking PGs (Product Groups) to drive towards a fix here as described in detail in issue [#2786 Create VNET without destroying all subnets `Azure/azure-quickstart-templates`](https://github.com/Azure/azure-quickstart-templates/issues/2786).

We are considering creating and providing additional scripts/guidance/templates to help you handle this scenario with the module, if experienced, but have decided not to invest in this for a `v1.0.0` release. However, if we have a number of issues created asking for this, this will help us prioritize this for the next release, so please do create an issue if you run into this 👍

#### Why doesn't the module just provide the ability to create Subnets as part of the Virtual Network deployment?

Good question, and it is something we considered initially however, due to the Subnets resource being a very complex array of objects (as can be seen [here](https://learn.microsoft.com/azure/templates/microsoft.network/virtualnetworks?pivots=deployment-language-bicep)) we decided not to add support for these in our Subscription vending module for both Bicep and Terraform as these would be error prone for consumers to provide correctly formatted subnet parameters. Plus with the lack of intellisense support in Bicep for parameters that are complex objects/arrays today, we felt this was the best approach for the time being.

> It should be noted though that the Bicep team are looking to implement support for `customTypes` which should provide intellisense support in Bicep for complex object/array parameters. When this is available, we may consider adding subnet support into this module. Again please [raise an issue](https://github.com/Azure/bicep-lz-vending/issues/new/choose) to let us know if you would like to see this, when available 👍
