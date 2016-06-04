$script:testCategory
### SET FOLDER TO WATCH + FILES TO WATCH + SUBFOLDERS YES/NO
$env:testCategory=$args[0]    
$curPath = Convert-Path .
$leafPath = Split-Path ($curPath) -Leaf
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = Convert-Path ..\
$watcher.Filter = "*.cs"
$watcher.IncludeSubdirectories = $true
$watcher.EnableRaisingEvents = $true
$watcher.Path

### DEFINE ACTIONS AFTER A EVENT IS DETECTED
$curPath = Convert-Path .
$action = {
    Write-Host
    Write-Host
    Write-Host "Rebuilding test..."  -foregroundcolor "magenta"
    Write-Host
    $curPath = Convert-Path .
    $leafPath = Split-Path ($curPath) -Leaf
    $result = & msbuild
    Write-Host "Testing..."  -foregroundcolor "magenta"
    Write-Host
    $result = & vstest.console $('"bin\Debug\'+$leafPath+'.dll"') '/Platform:x64' $('/TestCaseFilter:TestCategory='+$env:testCategory) | Out-String
    Write-Host $result

}    
### DECIDE WHICH EVENTS SHOULD BE WATCHED + SET CHECK FREQUENCY  
$created = Register-ObjectEvent $watcher "Created" -Action $action
$changed = Register-ObjectEvent $watcher "Changed" -Action $action
$deleted = Register-ObjectEvent $watcher "Deleted" -Action $action
& $action
while ($true) {sleep 1}
