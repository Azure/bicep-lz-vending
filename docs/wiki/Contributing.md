<!-- markdownlint-disable MD041 -->
## Contributing

- [Contributing](#contributing)
- [Recommended Learning](#recommended-learning)
  - [Bicep](#bicep)
  - [Git](#git)
- [Tooling](#tooling)
  - [Required Tooling](#required-tooling)
  - [Recommended Tooling](#recommended-tooling)
- [Bicep Formatting Guidelines](#bicep-formatting-guidelines)
  - [Bicep Best Practices](#bicep-best-practices)
  - [Bicep Code Styling](#bicep-code-styling)
  - [Bicep Module Documentation](#bicep-module-documentation)
  - [Resource API Versions](#resource-api-versions)
- [Git Information on Contributing](#git-information-on-contributing)

---

Looking to contribute to this project, whether that be Bicep code, examples, documentation or GitHub automation, you are in the right place. Please review the rest of this wiki page for important information to help you to start contributing to the project effectively.

## Recommended Learning

Before you start contributing to the ALZ Bicep code, it is **highly recommended** that you complete the following Microsoft Learn paths, modules & courses:

### Bicep

- [Deploy and manage resources in Azure by using Bicep](https://learn.microsoft.com/learn/paths/bicep-deploy/)
- [Structure your Bicep code for collaboration](https://learn.microsoft.com/learn/modules/structure-bicep-code-collaboration/)
- [Manage changes to your Bicep code by using Git](https://learn.microsoft.com/learn/modules/manage-changes-bicep-code-git/)

### Git

- [Introduction to version control with Git](https://learn.microsoft.com/learn/paths/intro-to-vc-git/)

## Tooling

### Required Tooling

To contribute to this project the following tooling is required:

- [Git](https://git-scm.com/downloads)
- [Bicep](https://learn.microsoft.com/azure/azure-resource-manager/bicep/install#install-manually)
- [Visual Studio Code](https://code.visualstudio.com/download)
  - [Bicep extension for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep)

![Bicep Logo](media/bicep-vs-code.png)

### Recommended Tooling

The following tooling/extensions are recommended to assist you developing for the project:

- [ARM Tools extension for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=msazurermtools.azurerm-vscode-tools)
- [ARM Template Viewer extension for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=bencoleman.armview)
- [EditorConfig for VS Code](https://marketplace.visualstudio.com/items?itemName=EditorConfig.EditorConfig)
- For visibility of Bracket Pairs:
  - Inside Visual Studio Code, add `"editor.bracketPairColorization.enabled": true` to your `settings.json`, to enable bracket pair colorization.

## Bicep Formatting Guidelines

The below guidelines should be adhered to whilst contributing to this projects Bicep code.

### Bicep Best Practices

Throughout the development of Bicep code you should follow the [Bicep Best Practices](https://learn.microsoft.com/azure/azure-resource-manager/bicep/best-practices).

> It is suggested to keep this page open whilst developing for easy reference

### Bicep Code Styling

- Strict `camelCasing` must be used for all elements:
  - Symbolic names for:
    - Parameters
    - Variables
    - Resource
    - Modules
    - Outputs
- Use [parameter decorators](https://learn.microsoft.com/azure/azure-resource-manager/bicep/parameters#decorators) to ensure integrity of user inputs are complete and therefore enable successful deployment
  - Only use the [`@secure()` parameter decorator](https://learn.microsoft.com/azure/azure-resource-manager/bicep/parameters#secure-parameters) for inputs. Never for outputs as this is not stored securely and will be stored/shown as plain-text!
- Comments should be provided where additional information/description of what is happening is required, except when a decorator like `@sys.description('Example description')` is providing adequate coverage
  - Single-line `// <comment here>` and multi-line `/* <comment here> */` comments are both welcomed
  - Provide contextual public Microsoft documentation recommendation references/URLs in comments to help user understanding of code implementation
- All expressions, used in conditionals and loops, should be stored in a variable to simplify code readability
- Specify default values for all parameters where possible - this improves deployment success
  - The default value should be called out in the description of the parameter for ease of visibility
  - Default values should also be documented in the appropriate location
- Tab indents should be set to `2` for all Bicep files
- Double line-breaks should exist between each element type section
- When intended for scopes above resource group deployment, targetScope should be indicated at the beginning of the file
- All parameters and outputs must have the following decorators:
  - `description` or `sys.description` (see below for more info)
  - `metadata` with an key called `example` key that has a value of an example parameter input value (see below for more info)

### Bicep Module Documentation

The [`main.bicep`](../../main.bicep) module has it's documentation automatically generated using [PSDocs.Azure](https://azure.github.io/PSDocs.Azure) from the Bicep module file itself and [this GitHub Action](../../.github/workflows/update-bicep-module-docs.yml) as part of PRs that amend this Bicep module.

Therefore, any changes made to the [`main.bicep.parameters.md`](../../main.bicep.parameters.md) file will not be accepted. Any changes to this file must be added to the [`main.bicep`](../../main.bicep) as decorators of either `description` or `metadata`. The PSDocs for Azure tooling details how metadata is used to generate documentation

> **Note:** the `@description` decorator in the `main.bicep` module specifically references the namespace of `sys` and is therefore shown as `@sys.description()` in the module. This is because there is a `metadata` resource that uses the name of `description` which therefore means we need to tell Bicep that it must use the `sys` namespace for all other instances of the `description` decorator usage instead of trying to refer to this `metadata` resource called `description`. More info on this can be found here [Namespaces for functions](https://learn.microsoft.com/azure/azure-resource-manager/bicep/bicep-functions#namespaces-for-functions)

### Resource API Versions

Each resource must use the latest available, working, API version. If the latest API version cannot be used for any reason, a comment must be placed above the resource in the module file stating why and also called out as part of the PR.

> The Bicep linter rule `use-recent-api-versions` will now also check for this 👍

## Git Information on Contributing

To make contributions to this repo you must fork and clone this repo. You can follow the guidance here on how to do this [Fork a repo](https://docs.github.com/get-started/quickstart/fork-a-repo)

You **will not** be able to create a branch or push directly to this repo. All changes into this repo **must** be made via a Pull Request. This process is documented here: [Contributing to projects](https://docs.github.com/get-started/quickstart/contributing-to-projects)
