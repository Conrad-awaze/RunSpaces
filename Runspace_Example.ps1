Get-Runspace

$Runspace = [runspacefactory]::CreateRunspace()
$PowerShell = [powershell]::Create()

$PowerShell.Runspace = $Runspace
$Runspace.Open()
$PowerShell.AddScript({Start-Sleep 5})

$Job = $PowerShell.BeginInvoke()
$PowerShell.EndInvoke($Job)
$Runspace.Close()


$Scriptblock = {
    param($Name)
    New-Item -Name $Name -ItemType File
}

$MaxThreads = 5
$RunspacePool = [runspacefactory]::CreateRunspacePool(1, $MaxThreads)
$RunspacePool.Open()
$Jobs = @()

1..10 | Foreach-Object {
	$PowerShell = [powershell]::Create()
	$PowerShell.RunspacePool = $RunspacePool
	$PowerShell.AddScript($ScriptBlock).AddArgument($_)
	$Jobs += $PowerShell.BeginInvoke()
}

while ($Jobs.IsCompleted -contains $false) {
	Start-Sleep 1
}

