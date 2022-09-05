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
    $templateraw = Get-Content -Raw -Path $_.Templatefile;
    $templateName = $template.Name.Split('.')[0]
    $docName = "$($templateName)"
    $docNameWithoutExtension = [System.IO.Path]::GetFileNameWithoutExtension($template.Name)
    $docNameWithBicepExt = ($docNameWithoutExtension) + '.bicep'
    $jobj = ConvertFrom-Json -InputObject $templateraw
    $jobj.metadata | Add-Member -name "name" -Value "``$docNameWithBicepExt`` Parameters" -MemberType NoteProperty

    if ($docName -eq 'main') {
        $jobj.metadata | Add-Member -name "description" -Value "These are the input parameters for the Bicep module: [``$docNameWithBicepExt``](../../$docNameWithBicepExt)`r`n`r`n> For more information and examples please see the [wiki](https://github.com/Azure/bicep-lz-vending/wiki)" -MemberType NoteProperty
    }
    if ($docName -eq 'deploy') {
        $jobj.metadata | Add-Member -name "description" -Value "These are the input parameters for the Bicep module: [``$docNameWithBicepExt``](../../src/self/subResourceWrapper/$docNameWithBicepExt)`r`n`r`n> For more information and examples please see the [wiki](https://github.com/Azure/bicep-lz-vending/wiki)" -MemberType NoteProperty
    }

    $templatepath = $template.DirectoryName
    $convertedtemplatename = $template.Name
    $convertedfullpath = $templatepath + "\" + $convertedtemplatename
    $jobj | ConvertTo-Json -Depth 100 | Set-Content -Path $convertedfullpath
    

    # Generate markdown
    Write-Information -InformationAction Continue "====> Creating MD file using PSDocs.Azure for: $template"
    Invoke-PSDocument -Module PSDocs.Azure -OutputPath docs/PSDocs.Azure/ -InputObject $template.FullName -InstanceName $docName;
}

# Remove JSON files that were temporarily created
$docsToGenerate | ForEach-Object {
    Write-Information -InformationAction Continue "===> Removing: $($_)"
    Remove-Item $_ -Force
}