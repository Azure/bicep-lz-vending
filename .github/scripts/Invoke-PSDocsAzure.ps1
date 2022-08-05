# Import module
Import-Module PSDocs.Azure

# Bicep modules to create docs for in an array
$bicepModulesToBuild = @(
    '.\main.bicep'
    '.\src\self\subResourceWrapper\deploy.bicep'
)

# Bicep build the files in the array above and add newly created ARM/JSON files to new array for doc creations
$docsToGenerate = New-Object System.Collections.ArrayList

$bicepModulesToBuild | ForEach-Object {
    # Build Bicep file/module
    Write-Information -InformationAction Continue "===> Bicep Building: $($_)"
    bicep build $_

    # Remove Bicep extension from input path and replace with JSON instead
    $bicepPathSplit = $_.Split('.')[1]
    $jsonPathOutput = '.' + $bicepPathSplit + '.json'
    
    # Add to array for doc creation by PSDocs.Azure
    $docsToGenerate.Add($jsonPathOutput)
}

# Generate docs using PSDocs.Azure moudle from array created above and place into /docs/PSDocs.Azure folder
Get-AzDocTemplateFile -InputPath $docsToGenerate | ForEach-Object {
    # Generate a standard name of the markdown file. i.e. <name>_<version>.md

    $template = Get-Item -Path $_.TemplateFile
    $templateName = $template.Name.Split('.')[0]
    $docName = "$($templateName)"

    # Generate markdown
    Write-Information -InformationAction Continue "====> Creating MD file using PSDocs.Azure for: $template"
    Invoke-PSDocument -Module PSDocs.Azure -OutputPath docs/PSDocs.Azure/ -InputObject $template.FullName -InstanceName $docName;
}

# Remove JSON files that were temporarily created
$docsToGenerate | ForEach-Object {
    Write-Information -InformationAction Continue "===> Removing: $($_)"
    Remove-Item $_ -Force
}