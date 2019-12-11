#��������� �����
Write-Host "��������� �����" -foregroundcolor "DarkCyan"
Import-Module ServerManager
Add-WindowsFeature Web-Server, Web-Static-Content, Web-Default-Doc, Web-Dir-Browsing, Web-Http-Errors, Web-Asp-Net, Web-Net-Ext, Web-ASP, Web-CGI, Web-ISAPI-Ext, Web-ISAPI-Filter, Web-Http-Logging, Web-Log-Libraries, Web-Request-Monitor, Web-Http-Tracing, Web-ODBC-Logging, Web-Basic-Auth, Web-Windows-Auth, Web-Digest-Auth, Web-Client-Auth, Web-Cert-Auth, Web-Url-Auth, Web-Filtering, Web-IP-Security, Web-Stat-Compression, Web-Dyn-Compression, Web-Mgmt-Console, Web-Scripting-Tools, Web-Mgmt-Service, Web-Mgmt-Compat, Web-Metabase, Web-WMI, Web-Lgcy-Scripting, Web-Lgcy-Mgmt-Console, SMTP-Server
Write-Host "`n`n`n`n`n`n`n`n"
Write-Host "��������� SMTPSVC �� �������������� ������" -foregroundcolor "DarkCyan"
set-service SMTPSVC -StartupType "Automatic"
Write-Host "������� ����� ������� ��� �����������..."
$x=$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

#��������� ���������� KB
Write-Host "��������� ���������� KB" -foregroundcolor "DarkCyan"
$test = (get-service wuauserv).status
if ($test -eq "Stopped") {Write-Host "������ Windows Update �� ��������. ��������� ������ Windows Update � ������� ����� ������� ��� �����������"; $x=$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")}
$defpath = Get-Content Path.txt
#$path = read-host "������� ���� �� KB (������ - �:\temp\Updates)"
$a = get-item $defpath\Updates\*.msu | sort-object name
foreach ($file in $a) {$filename = $file.name; Write-Host "������������ $filename"; Start-Process -Filepath wusa.exe -ArgumentList "$defpath\updates\$filename /quiet /norestart" -Wait}
Write-Host "������� ����� ������� ��� �����������..."
$x=$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

#���������� �����
Write-Host "���������� �����" -foregroundcolor "DarkCyan"
$services = "wuauserv","Dhcp","Browser","Spooler","dot3svc","WinHttpAutoProxySvc"
foreach ($item in $services) {stop-service $item -Force;set-service $item -startuptype "Disabled";Write-Host "������������ ������ $item"}
Write-Host "������� ����� ������� ��� �����������..."
$x=$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

#���������� Firewall
Write-Host "���������� Firewall" -ForegroundColor "DarkCyan"
netsh advfirewall set allprofiles state off

#��������� .Net Framework 4.0
Write-Host "��������� .Net Framework 4.0" -foregroundcolor "DarkCyan"
$defpath = Get-Content Path.txt
Start-Process -FilePath $defpath\NetFramework\dotNetFx40_Full_x86_x64.exe -ArgumentList "/q /norestart" -Wait
Write-Host "��� �������� ���������. ������� ����� ������� ��� ������������..." -foregroundcolor "DarkCyan"
$x=$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
restart-computer
