$Logname = "application"
$GroupName = "SVK Aibs"
$Rights = "(A;;0x4;;;"

#ПОлучение SID группы
$objUser = New-Object System.Security.Principal.NTAccount($GroupName)
$strSID = $objUser.Translate([System.Security.Principal.SecurityIdentifier])
$sid = $strSID.Value+")"

#Получение значения ChannelAccess
$a = wevtutil.exe gl $Logname
$ChannelAccessFull = $a[5]
$ChannelAccess = $ChannelAccessFull.Substring(15)

#Изменение значения ChannelAccess
wevtutil.exe sl $Logname /ca:$ChannelAccess$Rights$Sid