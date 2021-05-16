Clear-Host
#$desiredState  = ([byte[]](2,0,0,0,232,235,213,29,90,67,211,1,0,0,0,0,67,66,1,0,16,0,208,10,2,198,20,149,166,215,238,161,235,208,233,1,0))
#night = 2 0 0 0 199 91 231 198 81 107 210 1 0 0 0 0 67 66 1 0 2 1 202 20 14 21 0 202 30 14 7 0 207 40 208 15 202 50 14 16 46 49 0 202 60 14 8 46 47 0 0

#$path = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount\$$windows.data.bluelightreduction.bluelightreductionstate\Current'
#$path = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount\$$windows.data.bluelightreduction.bluelightreductionstate'
#$path = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount\$$windows.data.bluelightreduction.settings\Current'

$nightSetting = ([byte[]](2,0,0,0,199,91,231,198,81,107,210,1,0,0,0,0,67,66,1,0,2,1,202,20,14,21,0,202,30,14,7,0,207,40,208,15,202,50,14,16,46,49,0,202,60,14,8,46,47,0,0))
$daySetting = ([byte[]](0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0))

$Dayrecord = Get-ItemProperty $path
$diff = $Dayrecord.Data

Write-Host "Assuming you started this program with nightlight completely off select Y when you have it turned on"

$answer = Read-Host -Prompt "Enter Y when you have nightmode fully enabled"

if($answer -eq 'y' -or $answer -eq 'Y'){
    $nightRecord  = Get-ItemProperty $path
}

for($i = 0; $i -lt $diff.count;$i+=1){
    $diff[$i] = $diff[$i] - $nightRecord.data[$i]
}

Write-Host "  Day:"$Dayrecord.data
write-host "Night:"$nightRecord.data
write-host " Diff:"$diff