function switch-mode($recordPath = '.\ancillary_files\record.txt'){
    $record = get-record -path $recordPath

    if($record -eq "day"){
        set-NightMode -recordPath $recordPath
        return "night"
    }
    elseif($record -eq "night"){
        set-DayMode -recordPath $recordPath
        return "day"
    }
    else{
        set-NightMode -recordPath $recordPath
        return 'night'
    }
}
Export-ModuleMember -Function switch-mode
function set-DayMode($recordPath = '.\ancillary_files\record.txt'){
    #$baseData.daySetting = ([byte[]](0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0))
    Start-Process -FilePath '.\ancillary_files\day.bat' -WindowStyle Hidden #switches projection
    set-volumeByDevice -mode 'day'
    Start-Sleep -Seconds 3
    #set-nightlight -mode 'day' #sets nightlight off
    get-process -Name 'Dimmer'|<#Where-Object{$_.Path -eq ".\ancillary_files\dimmer\Dimmer.exe"}|#>Stop-Process
    Set-Content -Path $recordPath -Value "day"
}
Export-ModuleMember -Function set-DayMode
function set-NightMode($recordPath = '.\ancillary_files\record.txt'){
    #$nightSetting = ([byte[]](2,0,0,0,199,91,231,198,81,107,210,1,0,0,0,0,67,66,1,0,2,1,202,20,14,21,0,202,30,14,7,0,207,40,208,15,202,50,14,16,46,49,0,202,60,14,8,46,47,0,0))
    Start-Process -FilePath '.\ancillary_files\night.bat' -WindowStyle Hidden #switches projection
    set-volumeByDevice -mode 'night'
    Start-Sleep -Seconds 3
    #set-nightlight -mode 'night' #sets nightlight on
    Copy-Item -Path .\ancillary_files\nightSettings.json -Destination .\ancillary_files\dimmer\Dimmer.json -Force
    while($null -eq (Get-Process -Name *dimmer*)){
        Invoke-Item ".\ancillary_files\dimmer\Dimmer.exe"
    }
    Set-Content -Path $recordPath -Value "night"
}
Export-ModuleMember -Function set-NightMode
function set-nightlight(){
    #$regPath = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount\$$windows.data.bluelightreduction.settings\Current'
    #$nightSetting = ([byte[]](2,0,0,0,199,91,231,198,81,107,210,1,0,0,0,0,67,66,1,0,2,1,202,20,14,21,0,202,30,14,7,0,207,40,208,15,202,50,14,16,46,49,0,202,60,14,8,46,47,0,0))
    #$daySetting = ([byte[]](0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0))
    param(
        [ValidateSet("day","night")] $mode = 'day'
    )
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
    else{Write-Error "No affect made"}
}
Export-ModuleMember -Function set-nightlight
function get-record($path = '.\ancillary_files\record.txt'){
    $fileRecord = Get-content $path
    if($fileRecord -eq "day"){
        return "day"
    }
    elseif($fileRecord -eq "night"){
        return "night"
    }
    else{
        return "No Record"
    }
}
Export-ModuleMember -Function get-record
function get-audioFriendlyName() {
    param(
        $id = [audio]::GetDefault(0)
    )
    # [audio]::GetDefault(0) #this is the speaker
    # [audio]::GetDefault(1) #this is the mic
    $reg = "HKLM:\SYSTEM\CurrentControlSet\Enum\SWD\MMDEVAPI\$id"
    return (get-ItemProperty $reg).FriendlyName
}
Export-ModuleMember -Function get-audioFriendlyName
function set-volumeByDevice(){
    param(
        $id = $null,
        [ValidateSet('day','night')]$mode = 'night'
    )
    $audioDevice = get-audioFriendlyName
    & ($audioNamesValues[$audioDevice]).($mode)
}
Export-ModuleMember -Function set-volumeByDevice
$audioNamesValues = @{
    #use & $audioNamesValues.key.mode to execute command
    'Headphones (Realtek High Definition Audio(SST))' = @{
        day = {Set-SoundVolume 16}
        night = {Set-SoundVolume 8}
    }
    'Headphones (Jabra Elite 75t Stereo)' = @{
        day = {Set-SoundVolume 20}
        night = {Set-SoundVolume 8}
    }
}
Export-ModuleMember -Variable audioNamesValues
Function Set-SoundVolume 
{
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateRange(0,100)]
        [Int]
        $volume
    )

    # Calculate number of key presses. 
    $keyPresses = [Math]::Ceiling( $volume / 2 )
    
    # Create the Windows Shell object. 
    $obj = New-Object -ComObject WScript.Shell
    
    # Set volume to zero. 
    1..50 | ForEach-Object {  $obj.SendKeys( [char] 174 )  }
    
    # Set volume to specified level. 
    for( $i = 0; $i -lt $keyPresses; $i++ )
    {
        $obj.SendKeys( [char] 175 )
    }
}
Export-ModuleMember -Function Set-SoundVolume