# Export-ScriptedModules
## Export scripted PowerShell modules to Clipboard or ps1 file

PowerShell Modules can either be "Scripted" (Programmed in Powershell) or "Binary" (Written in C# and compiled.) If they are scripted the installed module is open-source, and can we can copy that code to wherever we want.

This can be used for applications that allow for remote scripts to be run, but do not work locally and cannot see modules. Or as a way to send a module to another person to use without needing to install the module themselves.

## Export to clipboard
Export-ScriptedModules [Get-DisplayConnectors](https://github.com/13r0ck/Get-DisplayConnectors)

## Export to ps1
Export-ScriptedModules [Get-DisplayConnectors](https://github.com/13r0ck/Get-DisplayConnectors) -path C:\<example path>

This module is not yet signed and uploaded to Powershell Gallery for easy install. Just Place the folder from this repository in a powershell modules folder on your Desktop
