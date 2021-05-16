Clear-Host
$regPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount\$$windows.data.bluelightreduction.bluelightreductionstate\Current'
#$regPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount\$$windows.data.bluelightreduction.bluelightreductionstate'
#$regPath = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount\$$windows.data.bluelightreduction.settings\Current'

#$regPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount\$$windows.data.bluelightreduction.settings\Current'

$depth = 3

$dayPath = 'C:\Users\LargeQuinzhee\Documents\GitHub\nightNday\jsons\day.json'
$nigthPath = 'C:\Users\LargeQuinzhee\Documents\GitHub\nightNday\jsons\night.json'

Write-Host "Press any key to capture daymode"
pause

$day = Get-ItemProperty -Path $regPath

#$day|Export-Clixml -Path  -Depth $depth -Force
$day|ConvertTo-JSON -Depth $depth| Set-Content -path $dayPath

Write-Host "Press any key to capture nightmode"
pause

$night = Get-ItemProperty -Path $regPath

#$night|Export-Clixml -Path  -Depth $depth -Force
$night|ConvertTo-JSON -Depth $depth| out-file -path $nigthPath

Write-Host "Done"
Pause

Write-Host "Would you like to emulate night form?"
$descision = Read-Host -Prompt "y/n"

if($descision -eq 'y'){
    $execute = Get-Content -Path $dayPath|ConvertFrom-Json
    Set-ItemProperty -Path $regPath -Name 'Data' -Value $execute.Data
}

