Get-Runspace

$ScriptBlock = { 

    Import-Module dbatools
    Get-Module -Name dbatools

}

$RunSpace = [runspacefactory]::CreateRunspace()
$PowerShell = [powershell]::Create()
$PowerShell.Runspace = $RunSpace
$RunSpace.Open()
$PowerShell.AddScript($ScriptBlock)
$Job = $PowerShell.BeginInvoke()
$Job
$PowerShell.EndInvoke($Job)
$PowerShell.Dispose()
$RunSpace.Close()