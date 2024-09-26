# Azure Pipelines

## Introduction
<img src="https://github.com/geekfog.png" alt="geekfog" style="zoom:30%; float:right" />This is a public [GitHub contribution](https://github.com/geekfog/Azure-Pipelines) by Hans Dickel to help with Azure DevOps Pipeline Automation. While primarily focused on .NET, it can be extended to beyond.

What initially started as having a collection of Azure DevOps Pipelines Task Groups has changed to Step Templates.  These templates can be referenced directly from the GitHub repository from various pipelines (including Azure Pipelines YAML build files in various Repos) without requiring downloading of utility files into the pipeline.

## Using
The simplest way to reference these templates is to use the following in your YAML files (e.g., *azure-pipelines.yml*):

```
resources:
  repositories:
    - repository: templates
      type: github
      name: geekfog/Azure-Pipelines
      endpoint: my-service-connect-to-github # Azure DevOps service connection to GitHub

steps:
- template: replace-token.yml@templates
  parameters:
    DisplayName: '[Replace Token: SQL Connection String]'
    FileWithPath: 'webapp\web.config'
    BackupFileExtension: 'original'
    RestoreBackup: 'no'
    TokenString: '$DBCONNSTR'
    TokenValue: '$(my-app-connectionstring-var)' # Could come from Azure Vault or Variable in Pipeline Build or Release
```

Some additional notes:
1. The **name** referencing *geekfog/Azure-Pipelines* within the resources is the GitHub company and repo. This [repo](https://github.com/geekfog/Azure-Pipelines.git) can be forked to another organization's or individual's repo to be extended or referenced (which can create safety of its existence and at a particular version state), switching out *geekfog* with the extended repo name (cloned to).
2. The **repository** *templates* is cross-referenced within the template mentioned with the YAML file.

## Contributions

While there are no expected contributions, they are welcome via GitHub.

## Resources
[Microsoft Documentation on Pipelines Step Templates](https://docs.microsoft.com/en-us/azure/devops/pipelines/process/templates?view=azure-devops)

\~End~
