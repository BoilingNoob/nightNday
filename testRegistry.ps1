$desiredState  = ([byte[]](2,0,0,0,232,235,213,29,90,67,211,1,0,0,0,0,67,66,1,0,16,0,208,10,2,198,20,149,166,215,238,161,235,208,233,1,0))

$path = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount\$$windows.data.bluelightreduction.bluelightreductionstate\Current'

$record = Get-ItemProperty $path
$record

Write-Host "Replace 1 with 2"

Write-Host $record.data

Write-Host $desiredState

$response = Read-Host -Prompt "y/n"

if($response -eq 'y'){
    write-host "night"
    Set-ItemProperty $path -Name Data -Value $desiredState

    Start-Sleep -Seconds 30
    
    Write-Host "time ending, day!"
    Set-ItemProperty $path -Name Data -Value $record.data
}
