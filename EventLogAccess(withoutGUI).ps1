$Logname = "application"
$GroupName = "SVK Aibs"
$Rights = "(A;;0x4;;;"

#��������� SID ������
$objUser = New-Object System.Security.Principal.NTAccount($GroupName)
$strSID = $objUser.Translate([System.Security.Principal.SecurityIdentifier])
$sid = $strSID.Value+")"

#��������� �������� ChannelAccess
$a = wevtutil.exe gl $Logname
$ChannelAccessFull = $a[5]
$ChannelAccess = $ChannelAccessFull.Substring(15)

#��������� �������� ChannelAccess
wevtutil.exe sl $Logname /ca:$ChannelAccess$Rights$Sid