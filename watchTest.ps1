$script:testCategory
### SET FOLDER TO WATCH + FILES TO WATCH + SUBFOLDERS YES/NO
$env:testCategory=$args[0]
$env:target='Debug'
if ($($args.Count) -gt 1) {
    $env:target=$args[1]
}
$env:platform='AnyCPU'
if ($($args.Count) -gt 2) {
    $env:platform=$args[2]
}
if ($env:platform -eq 'AnyCPU') {
    $env:platformTest='x64'    
} else {
    $env:platformTest=$env:platform
}
if ($($args.Count) -gt 3) {
    $env:platformTest=$args[3]
}

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
    $curPath = Convert-Path .
    $leafPath = Split-Path ($curPath) -Leaf
    $result = & msbuild $('/p:Configuration='+$env:target) $('/p:Platform='+$env:platform) | Out-String
    Write-Host $result
    Write-Host
    Write-Host "Testing..."  -foregroundcolor "magenta"
    Write-Host
    $result = & vstest.console $('"bin\'+$env:target+'\'+$leafPath+'.dll"') $('/Platform:'+$env:platformTest) $('/TestCaseFilter:TestCategory='+$env:testCategory) | Out-String
    Write-Host $result

}    
### DECIDE WHICH EVENTS SHOULD BE WATCHED + SET CHECK FREQUENCY  
$created = Register-ObjectEvent $watcher "Created" -Action $action
$changed = Register-ObjectEvent $watcher "Changed" -Action $action
$deleted = Register-ObjectEvent $watcher "Deleted" -Action $action
& $action
while ($true) {sleep 1}
