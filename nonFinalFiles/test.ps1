Clear-Host
$hold = get-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount\$$windows.data.bluelightreduction.bluelightreductionstate\Current'
$hold.data|Export-Clixml -Path .\holding_Registry_day.xml -Depth 5000