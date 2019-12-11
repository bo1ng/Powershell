$ip = Read-Host "Введите IP-адрес ПСВА (например - 192.168.150.4)"
$region = Read-Host "Введите имя региона (например - tver)"

#Создание нового хэндлера приема с HostName = WmqHost для адаптера MQSeries
Write-Host "Работа с ReceiveHandler MQSeries Adapter..." -foregroundcolor "DarkCyan"
$q = Get-WmiObject MSBTS_ReceiveHandler -Namespace 'root\MicrosoftBiztalkServer'| Where-Object {$_.adaptername -match "MQSeries"}
$q.HostName = "WmqHost"
$q.put() | Out-Null

#Удаление старого хэндлера приема с HostName = TrackingHost для адаптера MQSeries
$d = Get-WmiObject MSBTS_ReceiveHandler -Namespace 'root\MicrosoftBiztalkServer'| Where-Object {$_.adaptername -match "MQSeries" -and $_.hostname -match "TrackingHost"}
$d.Delete() | Out-Null

#Изменение настроек хэндлера приема
$q = Get-WmiObject MSBTS_ReceiveHandler -Namespace 'root\MicrosoftBiztalkServer' | Where-Object {$_.adaptername -match "MQSeries" -and $_.hostname -match "WmqHost"}
$q.CustomCfg = "<CustomProps><AdapterConfig vt='8'>&lt;Config xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema'&gt;&lt;serverName&gt;localhost&lt;/serverName&gt;&lt;/Config&gt;</AdapterConfig></CustomProps>"
$q.put() | Out-Null

#Изменение хэндлера отправки на HostName = WmqHost  для адаптера MQSeries
Write-Host "Работа с SendHandler MQSeries Adapter..." -foregroundcolor "DarkCyan"
$s = Get-WmiObject MSBTS_SendHandler -Namespace 'root\MicrosoftBiztalkServer'| Where-Object {$_.adaptername -match "MQSeries"}
$s.HostName = "WmqHost"
$s.CustomCfg = "<CustomProps><AdapterConfig vt='8'>&lt;Config xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema'&gt;&lt;serverName&gt;localhost&lt;/serverName&gt;&lt;maximumNumberOfMessages&gt;100&lt;/maximumNumberOfMessages&gt;&lt;/Config&gt;</AdapterConfig></CustomProps>"
$s.put() | Out-Null

#Изменение хэндлера отправки на HostName = SmtpHost для адаптера SMTP
Write-Host "работа с SendHandler SMTP Adapter..." -foregroundcolor "DarkCyan"
$smtp = Get-WmiObject MSBTS_SendHandler -Namespace 'root\MicrosoftBiztalkServer' | Where-Object {$_.adaptername -match "SMTP"}
$smtp.HostName = "SmtpHost"
$smtp.CustomCfg = "<CustomProps><SMTPHost vt='8'>$ip</SMTPHost><SMTPAuthenticate vt='19'>0</SMTPAuthenticate><From vt='8'>gateway@svk.$region.cbr.ru</From></CustomProps>"
$smtp.put() | Out-Null

#Создание нового хэндлера приема с HostName = ExternalHost для адаптера FILE
Write-Host "Работа с ReceiveHandler FILE Adapter..." -foregroundcolor "DarkCyan"
$file = Get-WmiObject MSBTS_ReceiveHandler -Namespace 'root\MicrosoftBiztalkServer'| Where-Object {$_.adaptername -match "FILE"}
$file.HostName = "ExternalHost"
$file.put() | Out-Null

#Удаление старого хэндлера приема с HostName = TrackingHost для адаптера FILE
$d = Get-WmiObject MSBTS_ReceiveHandler -Namespace 'root\MicrosoftBiztalkServer'| Where-Object {$_.adaptername -match "FILE" -and $_.hostname -match "TrackingHost"}
$d.Delete() | Out-Null

#Изменение хэндлера отправки на HostName = ExternalHost  для адаптера FILE
Write-Host "Работа с SendHandler FILE Adapter..." -foregroundcolor "DarkCyan"
$file = Get-WmiObject MSBTS_SendHandler -Namespace 'root\MicrosoftBiztalkServer'| Where-Object {$_.adaptername -match "FILE"}
$file.HostName = "ExternalHost"
$file.put() | Out-Null

Write-Host "Перезапуск служб Biztalk Services" -foregroundcolor "DarkCyan"
Restart-Service BtsSvc*
Write-Host "Изменение хэндлеров выполнено!" -foregroundcolor "DarkCyan"
Write-Host "Нажмите любую клавишу для продолжения..."
$x=$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

