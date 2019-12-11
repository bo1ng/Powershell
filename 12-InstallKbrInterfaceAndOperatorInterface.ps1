#$path = Read-Host "Введите путь до дистрибутива KbrInterface.msi и OperatorInterface.msi (пример - C:\Scripts\msi)"
$region = Read-Host "Введите имя региона (например - tver)"
$defpath = Get-Content Path.txt

Write-Host "Создание пула приложения KbrInterface и OperatorInterface" -ForegroundColor "DarkCyan"
cd "$defpath\http"
Start-Process -Filepath "CreateAppPools.bat" -Wait

Write-Host "Создание физических директорий" -ForegroundColor "DarkCyan"
New-Item "C:\Program Files\ACS\KbrInterface" -type directory
New-Item "C:\Program Files\ACS\OperatorInterface" -type directory

Write-Host "Создание вирутальных директорий в IIS" -ForegroundColor "DarkCyan"
Import-Module WebAdministration
New-WebVirtualDirectory -Site "Default Web Site" -Name "KbrInterface" -PhysicalPath "C:\Program Files\ACS\KbrInterface" | Out-Null
New-WebVirtualDirectory -Site "Default Web Site" -Name "OperatorInterface" -PhysicalPath "C:\Program Files\ACS\OperatorInterface" | Out-Null

Write-Host "Установка KbrInterface.msi" -foregroundcolor "DarkCyan"
Start-Process -filepath "$defpath\msi\KbrInterface.msi" -ArgumentList "/norestart /q" -Wait
Write-Host "Установка OperatorInterface.msi" -foregroundcolor "DarkCyan"
Start-Process -filepath "$defpath\msi\OperatorInterface.msi" -ArgumentList "/norestart /q" -Wait

cd "IIS:\Sites\Default Web Site\"
set-ItemProperty KbrInterface -name "ApplicationPool" -Value "KbrAppPool"
set-ItemProperty OperatorInterface -name "ApplicationPool" -Value "OperatorAppPool"

Write-Host "Настройка Authentication для KbrInterface" -ForegroundColor "DarkCyan"
cd 'IIS:\Sites\Default Web Site\KbrInterface'
set-WebConfigurationProperty -filter /system.webServer/security/authentication/AnonymousAuthentication -name enabled -Value false -PSPath IIS:\ -location "Default Web Site/KbrInterface"
set-WebConfigurationProperty -filter /system.webServer/security/authentication/digestAuthentication -name enabled -Value true -PSPath IIS:\ -location "Default Web Site/KbrInterface"
set-WebConfigurationProperty -filter /system.webServer/security/authentication/digestAuthentication -name realm -value "svk.$region.cbr.ru" -PSPath IIS:\ -location "Default Web Site/KbrInterface"

Write-Host "Настройка Authentication для OperatorInterface" -ForegroundColor "DarkCyan"
cd 'IIS:\Sites\Default Web Site\KbrInterface'
set-WebConfigurationProperty -filter /system.webServer/security/authentication/AnonymousAuthentication -name enabled -Value false -PSPath IIS:\ -location "Default Web Site/OperatorInterface"
set-WebConfigurationProperty -filter /system.webServer/security/authentication/digestAuthentication -name enabled -Value true -PSPath IIS:\ -location "Default Web Site/OperatorInterface"


Write-Host "Настройка Authorization для KbrInterface" -ForegroundColor "DarkCyan"
Add-WebConfiguration -Filter /System.WebServer/Security/Authorization -Value (@{AccessType="Allow"; Roles="SVK\SVK Users"; Permissions="Read, Write"}) -PSPath IIS:\ -location "Default Web Site/KbrInterface"
Add-WebConfiguration -Filter /System.WebServer/Security/Authorization -Value (@{AccessType="Allow"; Roles="SVK\SVK Administrators"; Permissions="Read, Write"}) -PSPath IIS:\ -location "Default Web Site/KbrInterface"
Add-WebConfiguration -Filter /System.WebServer/Security/Authorization -Value (@{AccessType="Allow"; Roles="SVK\SVK Operators"; Permissions="Read, Write"}) -PSPath IIS:\ -location "Default Web Site/KbrInterface"
Add-WebConfiguration -Filter /System.WebServer/Security/Authorization -Value (@{AccessType="Allow"; Roles="SVK\Administrators"; Permissions="Read, Write"}) -PSPath IIS:\ -location "Default Web Site/KbrInterface"


Write-Host "Настройка Authorization для OperatorInterface" -ForegroundColor "DarkCyan"
Add-WebConfiguration -Filter /System.WebServer/Security/Authorization -Value (@{AccessType="Allow"; Roles="SVK\SVK Aibs"; Permissions="Read, Write"}) -PSPath IIS:\ -location "Default Web Site/OperatorInterface"
Add-WebConfiguration -Filter /System.WebServer/Security/Authorization -Value (@{AccessType="Allow"; Roles="SVK\SVK Administrators"; Permissions="Read, Write"}) -PSPath IIS:\ -location "Default Web Site/OperatorInterface"
Add-WebConfiguration -Filter /System.WebServer/Security/Authorization -Value (@{AccessType="Allow"; Roles="SVK\SVK Operators"; Permissions="Read, Write"}) -PSPath IIS:\ -location "Default Web Site/OperatorInterface"
Add-WebConfiguration -Filter /System.WebServer/Security/Authorization -Value (@{AccessType="Allow"; Roles="SVK\Administrators"; Permissions="Read, Write"}) -PSPath IIS:\ -location "Default Web Site/OperatorInterface"

Write-Host "Включение .NetFramework4" -ForegroundColor "DarkCyan"
Set-Webconfiguration "/system.webserver/security/isapicgirestriction/add[@allowed='false']/@allowed" -value "True" -PsPath:IIS:\

Write-Host "Внимание!!! Для приложений KbrInterface и OperatorInterface необходимо в разделе Authorization удалить запись All Users - Allow" -ForegroundColor "DarkYellow"
Write-Host "Внимание!!! Не забудьте настроить IP-адреса доступа к OperatorInterface" -ForegroundColor "DarkYellow"

Write-Host "Установка и конфигурирование завершено." -ForegroundColor "DarkCyan"
Write-Host "Нажмите любую клавишу для продолжения..."
$x=$host.UI.RawUI.ReadKey("NoEcho, IncludeKeyDown")
