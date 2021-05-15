function get-record($path = 'record.txt')
{
    $fileRecord = Get-ChildItem $path
    return $fileRecord
}

function set-NightMode()
{
    <#invoke-item -path C:\Users\LargeQuinzhee\Desktop\NightAndDay\night.bat#>
    Start-Process -FilePath C:\Users\LargeQuinzhee\Desktop\NightAndDay\night.bat -WindowStyle Hidden
}

function set-DayMode()
{
    <#invoke-item -path C:\Users\LargeQuinzhee\Desktop\NightAndDay\day.bat#>
    Start-Process -FilePath C:\Users\LargeQuinzhee\Desktop\NightAndDay\day.bat -WindowStyle Hidden
}


#$record = get-record

#$record

#set-NightMode
#set-DayMode