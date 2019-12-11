Import-Module webadministration
$defpath = Get-Content Path.txt

Write-Host "Установка MonitoringInfo.msi" -ForegroundColor "DarkCyan"
cd "$defpath\SystemMonitoring\Msi"
Start-Process -FilePath "MonitoringInfo.msi" -ArgumentList "/norestart /q" -Wait

Write-Host "Настройка Application Pool" -ForegroundColor "DarkCyan"
cd "IIS:\Sites\Default Web Site\"
set-ItemProperty MonitoringInfo -name "ApplicationPool" -Value "ASP.NET v4.0 Classic"

Write-Host "Добавление пользователя svk/MonitoringUser в группу SVK-GATE/IIS_IUSRS" -ForegroundColor "DarkCyan"
$DomainUser = [ADSI]("WinNT://svk/MonitoringUser, user")
$LocalGroup = [ADSI]("WinNT://SVK-GATE/IIS_IUSRS")
$LocalGroup.PSBase.Invoke("Add",$DomainUser.PSBase.Path)
#>

Write-Host "Установка службы мониторинга"
cd "$defpath/SYstemMonitoring"
Start-Process -FilePath "install.svk-gate.cmd" -Wait

Write-Host "Установка и конфигурирование завершено." -ForegroundColor "DarkCyan"
Write-Host "Нажмите любую клавишу для продолжения..."
$x=$host.UI.RawUI.ReadKey("NoEcho, IncludeKeyDown")
