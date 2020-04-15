function Find-InInstalledVersions {
    Param($installed_modules, $ModuleName)
    $module = $installed_modules.modules.FirstChild
    while ($module -ne $null) {
        if ($module.ModuleName -eq $ModuleName) {
            break;
        }
        $module = $module.NextSibling
    }
    return $module
}

function Export-AmnetModule {
    Param(
        [Parameter(Mandatory=$true,
                   HelpMessage='Enter the name of the Module that you would like to be exported. It must be an AmnetModule')] 
                   [ValidateNotNullOrEmpty()] 
                   [Alias('M')]  
                   $ModuleName,

        [Parameter(HelpMessage='This is the path to the installed_modules.xml file. If this was not found automatically try running Update-AmnetModule to reinstall that file.')]
                   [string]$installed_modules_path="$env:USERPROFILE\Documents\WindowsPowerShell\Modules\Update-AmnetModules\installed_modules.xml",
    
        [Parameter(HelpMessage='If you would rather have the ps1 be exported to a file rather than copied to your clipboard then specify the path that you would like the ps1 saved to.')]
                   [string]$ExportPath=" ",
    
        [Parameter(HelpMessage='Enter any switches that you would like to be attached to the script whether saved to file or copied to clipboard. Enter all of the switches within ""s, `nExample: "-Name Test -Verbose -Force"')]
                   [string]$ArgumentList
    )

    [xml]$installed_modules = Get-Content $installed_modules_path -Force
    # From the installed modules.xml find the module with the name given, and get the text content of that psm1
    $module = Find-InInstalledVersions $installed_modules $ModuleName
    if ($module -eq $null) {
        $ModuleName = (Get-Alias $ModuleName).ResolvedCommand.Name
    }
    $module = Find-InInstalledVersions $installed_modules $ModuleName
    if ($ModuleName -eq "$null") {
        Throw "That doesn't seem to be an installed AmnetModule nor the Alias for an AmnetModule"
    }
    $psm1_content = Get-Content "$($module.ModulePath)\$($module.ModuleName).psm1"

    # Get the number of line so that we can change that line
    $total_lines = 0
    foreach ($line in $psm1_content) {
        $total_lines++
    }
    #Change that line -> Remove the powershell module specific cmdlets
    for ($i=0; $i -le $total_lines; $i++) {
        if ($psm1_content[$i] -like "Export-ModuleMember*" -or $psm1_content[$i] -like "Set-Alias*") {
            $psm1_content[$i] = ""
        }
    }
    #Add the name of the function to the end of the file so that it calls itself thus when pasted it will run correctly as a scrpt rather than tying to be a module
    $psm1_content[-1] += "`n`n$($ModuleName) $ArgumentList"

    #If a path is specified then save the module as a script, otherwise just copy the Script to the clipboard
    if ($ExportPath -eq " ") {
        Set-Clipboard $psm1_content
        Write-Host "$ModuleName saved to your clipboard." -ForegroundColor Green
    } else {
        New-Item "$ExportPath\$($module.ModuleName).ps1" -ItemType File
        Set-Content "$ExportPath\($module.ModuleName).ps1" $psm1_content
        Write-Host "$ModuleName exported to $ExportPath\$($module.ModuleName).ps1" -ForegroundColor Green
    }
}

Export-ModuleMember -Function Export-AmnetModule