#Установка ролей
Write-Host "Установка ролей" -foregroundcolor "DarkCyan"
Import-Module ServerManager
Add-WindowsFeature Web-Server, Web-Static-Content, Web-Default-Doc, Web-Dir-Browsing, Web-Http-Errors, Web-Asp-Net, Web-Net-Ext, Web-ASP, Web-CGI, Web-ISAPI-Ext, Web-ISAPI-Filter, Web-Http-Logging, Web-Log-Libraries, Web-Request-Monitor, Web-Http-Tracing, Web-ODBC-Logging, Web-Basic-Auth, Web-Windows-Auth, Web-Digest-Auth, Web-Client-Auth, Web-Cert-Auth, Web-Url-Auth, Web-Filtering, Web-IP-Security, Web-Stat-Compression, Web-Dyn-Compression, Web-Mgmt-Console, Web-Scripting-Tools, Web-Mgmt-Service, Web-Mgmt-Compat, Web-Metabase, Web-WMI, Web-Lgcy-Scripting, Web-Lgcy-Mgmt-Console, SMTP-Server
Write-Host "`n`n`n`n`n`n`n`n"
Write-Host "Настройка SMTPSVC на автоматический запуск" -foregroundcolor "DarkCyan"
set-service SMTPSVC -StartupType "Automatic"
Write-Host "Нажмите любую клавишу для продолжения..."
$x=$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

#Установка обновлений KB
Write-Host "Установка обновлений KB" -foregroundcolor "DarkCyan"
$test = (get-service wuauserv).status
if ($test -eq "Stopped") {Write-Host "Служба Windows Update не запущена. Запустите службу Windows Update и нажмите любую клавишу для продолжения"; $x=$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")}
$defpath = Get-Content Path.txt
#$path = read-host "Введите путь до KB (формат - С:\temp\Updates)"
$a = get-item $defpath\Updates\*.msu | sort-object name
foreach ($file in $a) {$filename = $file.name; Write-Host "Устанавливаю $filename"; Start-Process -Filepath wusa.exe -ArgumentList "$defpath\updates\$filename /quiet /norestart" -Wait}
Write-Host "Нажмите любую клавишу для продолжения..."
$x=$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

#Отключение служб
Write-Host "Отключение служб" -foregroundcolor "DarkCyan"
$services = "wuauserv","Dhcp","Browser","Spooler","dot3svc","WinHttpAutoProxySvc"
foreach ($item in $services) {stop-service $item -Force;set-service $item -startuptype "Disabled";Write-Host "Останавливаю службу $item"}
Write-Host "Нажмите любую клавишу для продолжения..."
$x=$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

#Отключение Firewall
Write-Host "Отключение Firewall" -ForegroundColor "DarkCyan"
netsh advfirewall set allprofiles state off

#Установка .Net Framework 4.0
Write-Host "Установка .Net Framework 4.0" -foregroundcolor "DarkCyan"
$defpath = Get-Content Path.txt
Start-Process -FilePath $defpath\NetFramework\dotNetFx40_Full_x86_x64.exe -ArgumentList "/q /norestart" -Wait
Write-Host "Все операции завершены. Нажмите любую клавишу для перезагрузки..." -foregroundcolor "DarkCyan"
$x=$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
restart-computer
