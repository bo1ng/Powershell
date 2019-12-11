do {$path = Read-Host "Введите путь до setup.exe дистрибутива Biztalk Server 2010 (Например D:\Biztalk Server)"
    if ((Test-path "$path\setup.exe") -match "false")
        {
            Write-Host "В директории $path отсутствует установочный файл setup.msi" -ForegroundColor "red"
        }
    }
until ((Test-path "$path\setup.exe") -match "true" )
$defpath = Get-Content Path.txt
Write-Host "Установка Microsoft Biztalk Server 2010" -Foregroundcolor "DarkCyan"
Start-Process -Filepath "$path\setup.exe" -ArgumentList "/PASSIVE /ADDLOCAL Documentation,BizTalk,WMI,Runtime,Engine,MOT,MSMQ,AdminAndMonitoring,AdminTools,MonitoringAndTracking,BizTalkAdminSnapIn,BAMTools,PAM,WCFAdapter,WcfAdapterAdminTools,AdditionalApps,SSOAdmin,SSOServer,MQSeriesAgent /CABPATH $defpath\CAB\Bts2010Win2K8R2EN64.cab" -Wait
Write-Host "Установка обновления Microsoft Biztalk Server 2010" -Foregroundcolor "DarkCyan"
Start-Process -FIlepath "$defpath\CAB\BizTalk2010-CU9-KB3136004-ENU.exe" -ArgumentList "/passive" -Wait
Write-Host "Установка обновления завершена.Для продолжения нажмите любую клавишу..." -ForegroundColor "DarkCyan"

$defpath = Get-Content Path.txt
cd "$defpath\BtConfiguration"
#Создание пользователей UsersBts
Write-Host "Создание пользователей" -foregroundcolor "DarkCyan"
Write-Host  "SsoUser `nTrackingHostUser `nIsolatedHostUser"
Start-Process -Filepath "CreateUsersBts.bat" -wait

#Запуск Biztalk Server COnfiguration
Start-Process -FilePath "C:\Program Files (x86)\Microsoft BizTalk Server 2010\Configuration.exe"
Write-Host "Выполните конфигурирование Biztalk Server (Режим Custom, далее нажать Import Configuration и выбрать открывшийся конфиг и нажать Apply Configuration.)" -foregroundcolor "DarkYellow"
Write-host "По завершении настройки нажмите любую клавишу..." -ForegroundColor "DarkYellow"
$x=$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

#Создание пользователей UserHost
Write-Host "Создание пользователей"  -foregroundcolor "DarkCyan"
Write-Host "InternalHostUser `nExternalHostUser `nHttpHostUser `nSmtpHostUser `nWmqHostUser"
Start-Process -Filepath "CreateUsersHosts.bat" -Wait

#Создание пользователя MqsAgentUser
Write-Host "Создание пользователя MqsAgentUser"  -foregroundcolor "DarkCyan"
Start-Process -Filepath "CreateUserMqsAgent.bat" -Wait

#Создание хостов
Write-Host "Сохдание хостов" -foregroundcolor "DarkCyan"
Write-Host "ExternalHost `nInternalHost `nWmqHost `nSmtpHost `nHttpHost"
Start-Process -Filepath "CreateHosts.bat" -Wait

#Создание экземпляров хостов
Write-Host "Создание экземпляров хостов" -foregroundcolor "DarkCyan"
Write-Host "ExternalHost Instance `nInternalHost Instance `nWmqHost Instance `nSmtpHost Instance `nHttpHost Instance"
Start-Process -Filepath "CreateHostInstances.bat" -Wait

#Настройка служб на StartType "DelayedAuto"
Write-Host "Настройка служб на StartType DelayedAuto" -foregroundcolor "DarkCyan"
get-service BTSSvc* | foreach-object -process { sc.exe config $_.Name start= delayed-auto}
Write-Host "Не забудьте переименовать приложение в SVK" -foregroundcolor "DarkYellow"
Write-Host "Настройка завершена. Нажмите любую клавишу для перезагрузки..." -foregroundcolor "DarkCyan"
$x=$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
Restart-Computer
