$ip = Read-Host "������� IP-����� ���� (�������� - 192.168.150.4)"
$region = Read-Host "������� ��� ������� (�������� - tver)"

#�������� ������ �������� ������ � HostName = WmqHost ��� �������� MQSeries
Write-Host "������ � ReceiveHandler MQSeries Adapter..." -foregroundcolor "DarkCyan"
$q = Get-WmiObject MSBTS_ReceiveHandler -Namespace 'root\MicrosoftBiztalkServer'| Where-Object {$_.adaptername -match "MQSeries"}
$q.HostName = "WmqHost"
$q.put() | Out-Null

#�������� ������� �������� ������ � HostName = TrackingHost ��� �������� MQSeries
$d = Get-WmiObject MSBTS_ReceiveHandler -Namespace 'root\MicrosoftBiztalkServer'| Where-Object {$_.adaptername -match "MQSeries" -and $_.hostname -match "TrackingHost"}
$d.Delete() | Out-Null

#��������� �������� �������� ������
$q = Get-WmiObject MSBTS_ReceiveHandler -Namespace 'root\MicrosoftBiztalkServer' | Where-Object {$_.adaptername -match "MQSeries" -and $_.hostname -match "WmqHost"}
$q.CustomCfg = "<CustomProps><AdapterConfig vt='8'>&lt;Config xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema'&gt;&lt;serverName&gt;localhost&lt;/serverName&gt;&lt;/Config&gt;</AdapterConfig></CustomProps>"
$q.put() | Out-Null

#��������� �������� �������� �� HostName = WmqHost  ��� �������� MQSeries
Write-Host "������ � SendHandler MQSeries Adapter..." -foregroundcolor "DarkCyan"
$s = Get-WmiObject MSBTS_SendHandler -Namespace 'root\MicrosoftBiztalkServer'| Where-Object {$_.adaptername -match "MQSeries"}
$s.HostName = "WmqHost"
$s.CustomCfg = "<CustomProps><AdapterConfig vt='8'>&lt;Config xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema'&gt;&lt;serverName&gt;localhost&lt;/serverName&gt;&lt;maximumNumberOfMessages&gt;100&lt;/maximumNumberOfMessages&gt;&lt;/Config&gt;</AdapterConfig></CustomProps>"
$s.put() | Out-Null

#��������� �������� �������� �� HostName = SmtpHost ��� �������� SMTP
Write-Host "������ � SendHandler SMTP Adapter..." -foregroundcolor "DarkCyan"
$smtp = Get-WmiObject MSBTS_SendHandler -Namespace 'root\MicrosoftBiztalkServer' | Where-Object {$_.adaptername -match "SMTP"}
$smtp.HostName = "SmtpHost"
$smtp.CustomCfg = "<CustomProps><SMTPHost vt='8'>$ip</SMTPHost><SMTPAuthenticate vt='19'>0</SMTPAuthenticate><From vt='8'>gateway@svk.$region.cbr.ru</From></CustomProps>"
$smtp.put() | Out-Null

#�������� ������ �������� ������ � HostName = ExternalHost ��� �������� FILE
Write-Host "������ � ReceiveHandler FILE Adapter..." -foregroundcolor "DarkCyan"
$file = Get-WmiObject MSBTS_ReceiveHandler -Namespace 'root\MicrosoftBiztalkServer'| Where-Object {$_.adaptername -match "FILE"}
$file.HostName = "ExternalHost"
$file.put() | Out-Null

#�������� ������� �������� ������ � HostName = TrackingHost ��� �������� FILE
$d = Get-WmiObject MSBTS_ReceiveHandler -Namespace 'root\MicrosoftBiztalkServer'| Where-Object {$_.adaptername -match "FILE" -and $_.hostname -match "TrackingHost"}
$d.Delete() | Out-Null

#��������� �������� �������� �� HostName = ExternalHost  ��� �������� FILE
Write-Host "������ � SendHandler FILE Adapter..." -foregroundcolor "DarkCyan"
$file = Get-WmiObject MSBTS_SendHandler -Namespace 'root\MicrosoftBiztalkServer'| Where-Object {$_.adaptername -match "FILE"}
$file.HostName = "ExternalHost"
$file.put() | Out-Null

Write-Host "���������� ����� Biztalk Services" -foregroundcolor "DarkCyan"
Restart-Service BtsSvc*
Write-Host "��������� ��������� ���������!" -foregroundcolor "DarkCyan"
Write-Host "������� ����� ������� ��� �����������..."
$x=$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

