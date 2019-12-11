#$path = Read-Host "������� ���� �� ������������ KbrInterface.msi � OperatorInterface.msi (������ - C:\Scripts\msi)"
$region = Read-Host "������� ��� ������� (�������� - tver)"
$defpath = Get-Content Path.txt

Write-Host "�������� ���� ���������� KbrInterface � OperatorInterface" -ForegroundColor "DarkCyan"
cd "$defpath\http"
Start-Process -Filepath "CreateAppPools.bat" -Wait

Write-Host "�������� ���������� ����������" -ForegroundColor "DarkCyan"
New-Item "C:\Program Files\ACS\KbrInterface" -type directory
New-Item "C:\Program Files\ACS\OperatorInterface" -type directory

Write-Host "�������� ����������� ���������� � IIS" -ForegroundColor "DarkCyan"
Import-Module WebAdministration
New-WebVirtualDirectory -Site "Default Web Site" -Name "KbrInterface" -PhysicalPath "C:\Program Files\ACS\KbrInterface" | Out-Null
New-WebVirtualDirectory -Site "Default Web Site" -Name "OperatorInterface" -PhysicalPath "C:\Program Files\ACS\OperatorInterface" | Out-Null

Write-Host "��������� KbrInterface.msi" -foregroundcolor "DarkCyan"
Start-Process -filepath "$defpath\msi\KbrInterface.msi" -ArgumentList "/norestart /q" -Wait
Write-Host "��������� OperatorInterface.msi" -foregroundcolor "DarkCyan"
Start-Process -filepath "$defpath\msi\OperatorInterface.msi" -ArgumentList "/norestart /q" -Wait

cd "IIS:\Sites\Default Web Site\"
set-ItemProperty KbrInterface -name "ApplicationPool" -Value "KbrAppPool"
set-ItemProperty OperatorInterface -name "ApplicationPool" -Value "OperatorAppPool"

Write-Host "��������� Authentication ��� KbrInterface" -ForegroundColor "DarkCyan"
cd 'IIS:\Sites\Default Web Site\KbrInterface'
set-WebConfigurationProperty -filter /system.webServer/security/authentication/AnonymousAuthentication -name enabled -Value false -PSPath IIS:\ -location "Default Web Site/KbrInterface"
set-WebConfigurationProperty -filter /system.webServer/security/authentication/digestAuthentication -name enabled -Value true -PSPath IIS:\ -location "Default Web Site/KbrInterface"
set-WebConfigurationProperty -filter /system.webServer/security/authentication/digestAuthentication -name realm -value "svk.$region.cbr.ru" -PSPath IIS:\ -location "Default Web Site/KbrInterface"

Write-Host "��������� Authentication ��� OperatorInterface" -ForegroundColor "DarkCyan"
cd 'IIS:\Sites\Default Web Site\KbrInterface'
set-WebConfigurationProperty -filter /system.webServer/security/authentication/AnonymousAuthentication -name enabled -Value false -PSPath IIS:\ -location "Default Web Site/OperatorInterface"
set-WebConfigurationProperty -filter /system.webServer/security/authentication/digestAuthentication -name enabled -Value true -PSPath IIS:\ -location "Default Web Site/OperatorInterface"


Write-Host "��������� Authorization ��� KbrInterface" -ForegroundColor "DarkCyan"
Add-WebConfiguration -Filter /System.WebServer/Security/Authorization -Value (@{AccessType="Allow"; Roles="SVK\SVK Users"; Permissions="Read, Write"}) -PSPath IIS:\ -location "Default Web Site/KbrInterface"
Add-WebConfiguration -Filter /System.WebServer/Security/Authorization -Value (@{AccessType="Allow"; Roles="SVK\SVK Administrators"; Permissions="Read, Write"}) -PSPath IIS:\ -location "Default Web Site/KbrInterface"
Add-WebConfiguration -Filter /System.WebServer/Security/Authorization -Value (@{AccessType="Allow"; Roles="SVK\SVK Operators"; Permissions="Read, Write"}) -PSPath IIS:\ -location "Default Web Site/KbrInterface"
Add-WebConfiguration -Filter /System.WebServer/Security/Authorization -Value (@{AccessType="Allow"; Roles="SVK\Administrators"; Permissions="Read, Write"}) -PSPath IIS:\ -location "Default Web Site/KbrInterface"


Write-Host "��������� Authorization ��� OperatorInterface" -ForegroundColor "DarkCyan"
Add-WebConfiguration -Filter /System.WebServer/Security/Authorization -Value (@{AccessType="Allow"; Roles="SVK\SVK Aibs"; Permissions="Read, Write"}) -PSPath IIS:\ -location "Default Web Site/OperatorInterface"
Add-WebConfiguration -Filter /System.WebServer/Security/Authorization -Value (@{AccessType="Allow"; Roles="SVK\SVK Administrators"; Permissions="Read, Write"}) -PSPath IIS:\ -location "Default Web Site/OperatorInterface"
Add-WebConfiguration -Filter /System.WebServer/Security/Authorization -Value (@{AccessType="Allow"; Roles="SVK\SVK Operators"; Permissions="Read, Write"}) -PSPath IIS:\ -location "Default Web Site/OperatorInterface"
Add-WebConfiguration -Filter /System.WebServer/Security/Authorization -Value (@{AccessType="Allow"; Roles="SVK\Administrators"; Permissions="Read, Write"}) -PSPath IIS:\ -location "Default Web Site/OperatorInterface"

Write-Host "��������� .NetFramework4" -ForegroundColor "DarkCyan"
Set-Webconfiguration "/system.webserver/security/isapicgirestriction/add[@allowed='false']/@allowed" -value "True" -PsPath:IIS:\

Write-Host "��������!!! ��� ���������� KbrInterface � OperatorInterface ���������� � ������� Authorization ������� ������ All Users - Allow" -ForegroundColor "DarkYellow"
Write-Host "��������!!! �� �������� ��������� IP-������ ������� � OperatorInterface" -ForegroundColor "DarkYellow"

Write-Host "��������� � ���������������� ���������." -ForegroundColor "DarkCyan"
Write-Host "������� ����� ������� ��� �����������..."
$x=$host.UI.RawUI.ReadKey("NoEcho, IncludeKeyDown")
