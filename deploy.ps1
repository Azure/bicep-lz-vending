$inputObject = @{
  DeploymentName        = 'lz-vend-{0}' -f (-join (Get-Date -Format 'yyyyMMddTHHMMssffffZ')[0..63])
  ManagementGroupId     = '276a2ed9-1969-4990-ba6c-8ac801a64c09'
  Location              = 'uksouth'
  TemplateParameterFile = '.\main.parameters.json'
  TemplateFile          = ".\main.bicep"
}

New-AzManagementGroupDeployment @inputObject
