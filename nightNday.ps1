function get-record($path = 'record.txt')
{
    $fileRecord = Get-ChildItem $path
    return $fileRecord
}
#$regPath = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount\$$windows.data.bluelightreduction.settings\Current'
#$nightSetting = ([byte[]](2,0,0,0,199,91,231,198,81,107,210,1,0,0,0,0,67,66,1,0,2,1,202,20,14,21,0,202,30,14,7,0,207,40,208,15,202,50,14,16,46,49,0,202,60,14,8,46,47,0,0))
#$daySetting = ([byte[]](0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0))
function set-nightlight(){
    param(
        [ValidateSet("Day", "Night","day", "night")] $mode = 'Day'
    )
    $editingName = 'Data'
    
    $baseData = @{
        #RegPath = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount\$$windows.data.bluelightreduction.settings\Current'
        RegPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount\$$windows.data.bluelightreduction.bluelightreductionstate\Current'
        nightSetting = ([byte[]](2,0,0,0,199,91,231,198,81,107,210,1,0,0,0,0,67,66,1,0,2,1,202,20,14,21,0,202,30,14,7,0,207,40,208,15,202,50,14,16,46,49,0,202,60,14,8,46,47,0,0))
        daySetting = ([byte[]](0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0))
    }
    if($mode -eq 'Night' -or $mode -eq 'night'){
        Set-ItemProperty -Path $baseData.regPath -Name $editingName -Value $baseData.nightSetting
    }
    elseif($mode -eq 'Day' -or $mode -eq 'day'){
        Set-ItemProperty -Path $baseData.regPath -Name $editingName -Value $baseData.daySetting
    }
    else{
        Write-Error "No affect made"
    }
}
function set-NightMode($baseData)
{
    #$nightSetting = ([byte[]](2,0,0,0,199,91,231,198,81,107,210,1,0,0,0,0,67,66,1,0,2,1,202,20,14,21,0,202,30,14,7,0,207,40,208,15,202,50,14,16,46,49,0,202,60,14,8,46,47,0,0))
    Start-Process -FilePath C:\Users\LargeQuinzhee\Desktop\NightAndDay\night.bat -WindowStyle Hidden
    set-nightlight -mode Night
    Invoke-Item "C:\Users\LargeQuinzhee\Desktop\dimmer\Dimmer.exe"
}

function set-DayMode($baseData)
{
    #$baseData.daySetting = ([byte[]](0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0))
    Start-Process -FilePath C:\Users\LargeQuinzhee\Desktop\NightAndDay\day.bat -WindowStyle Hidden
    set-nightlight -mode Day
    get-process -Name 'Dimmer'|Where-Object{$_.Path -eq "C:\Users\LargeQuinzhee\Desktop\dimmer\Dimmer.exe"}|Stop-Process
}


set-nightlight -mode Night
#$record = get-record

#$record

#set-NightMode $baseData
#set-DayMode