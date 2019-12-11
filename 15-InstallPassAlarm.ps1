#$path = Read-Host "Введите путь до дистрибутива PassAlarm.msi (пример - C:\Scripts\msi)"
$defpath = Get-Content Path.txt
#$ip = Read-Host "Введите внешний ip-адрес ТШ (пример - 192.168.150.3)"
Write-Host "Установка PassAlarm.msi" -foregroundcolor "DarkCyan"
Start-Process -filepath "$defpath\msi\PassAlarm.msi" -ArgumentList "/norestart /q" -Wait

#Write-Host "Установка iis60rkt.exe. Необходимо выбрать только компонент SelfSSL" -foregroundcolor "DarkCyan"
#Start-Process -filepath "$defpath\msi\iis60rkt.exe" -Wait

#Write-Host "Установка сертификата по IP адресу"
#cd "C:\Program Files (x86)\IIS Resources\SelfSSL"
#Start-Process -Filepath "selfssl" -ArgumentList "/T /N:CN=$ip /V:10000" -wait

Write-Host "Установка и конфигурирование завершено. Необходимо настроить страницу ChangePassword.aspx на доступ по https" -ForegroundColor "DarkYellow"
Write-Host "Нажмите любую клавишу для продолжения..."
$x=$host.UI.RawUI.ReadKey("NoEcho, IncludeKeyDown")
