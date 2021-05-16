function get-record($path = '.\record.txt'){
    $fileRecord = Get-content $path
    if($fileRecord -eq "Day"){
        return "Day"
    }
    elseif($fileRecord -eq "Night"){
        return "Night"
    }
    else{
        return "No Record"
    }
}
#$regPath = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount\$$windows.data.bluelightreduction.settings\Current'
#$nightSetting = ([byte[]](2,0,0,0,199,91,231,198,81,107,210,1,0,0,0,0,67,66,1,0,2,1,202,20,14,21,0,202,30,14,7,0,207,40,208,15,202,50,14,16,46,49,0,202,60,14,8,46,47,0,0))
#$daySetting = ([byte[]](0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0))
function set-nightlight(){
    param(
        [ValidateSet("Day", "Night","day", "night")] $mode = 'Day'
    )
    $mode = $mode.ToLower()

    $editingName = 'Data'
    
    $baseData = @{
        #RegPath = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount\$$windows.data.bluelightreduction.settings\Current'
        RegPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount\$$windows.data.bluelightreduction.bluelightreductionstate\Current'
        nightSetting = ([byte[]](2,0,0,0,199,91,231,198,81,107,210,1,0,0,0,0,67,66,1,0,2,1,202,20,14,21,0,202,30,14,7,0,207,40,208,15,202,50,14,16,46,49,0,202,60,14,8,46,47,0,0))
        daySetting = ([byte[]](0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0))
    }
    if($mode -eq 'night'){
        Set-ItemProperty -Path $baseData.regPath -Name $editingName -Value $baseData.nightSetting
    }
    elseif($mode -eq 'day'){
        Set-ItemProperty -Path $baseData.regPath -Name $editingName -Value $baseData.daySetting
    }
    else{
        Write-Error "No affect made"
    }
}
function set-NightMode($recordPath = '.\record.txt'){
    #$nightSetting = ([byte[]](2,0,0,0,199,91,231,198,81,107,210,1,0,0,0,0,67,66,1,0,2,1,202,20,14,21,0,202,30,14,7,0,207,40,208,15,202,50,14,16,46,49,0,202,60,14,8,46,47,0,0))
    Start-Process -FilePath '.\night.bat' -WindowStyle Hidden
    set-nightlight -mode 'Night'
    Invoke-Item "C:\Users\LargeQuinzhee\Desktop\dimmer\Dimmer.exe"
    Set-Content -Path $recordPath -Value "Night"
}
function set-DayMode($recordPath = '.\record.txt'){
    #$baseData.daySetting = ([byte[]](0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0))
    Start-Process -FilePath '.\day.bat' -WindowStyle Hidden
    set-nightlight -mode 'Day'
    get-process -Name 'Dimmer'|Where-Object{$_.Path -eq "C:\Users\LargeQuinzhee\Desktop\dimmer\Dimmer.exe"}|Stop-Process
    Set-Content -Path $recordPath -Value "Day"
}
function switch-mode($recordPath = '.\record.txt'){
    $record = get-record

    if($record -eq "Day"){
        set-NightMode -recordPath $recordPath
    }
    elseif($record -eq "Night"){
        set-DayMode -recordPath $recordPath
    }
    else{
        set-NightMode -recordPath $recordPath
    }
}

#set-nightlight -mode Night
#$record = get-record

#$record

#set-NightMode $baseData
#set-DayMode

get-record