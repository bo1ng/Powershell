#$path = Read-Host "Введите путь до дистрибутива ACS.BizTalk.Adapter.Http.msi (пример - C:\Scripts\msi)"
$defpath = Get-Content Path.txt
$region = Read-Host "Введите имя региона"

Write-Host "Установка ACS.BizTalk.Adapter.Smtp" -foregroundcolor "DarkCyan"
Start-Process -filepath "$defpath\msi\ACS.BizTalk.Adapter.Smtp.msi" -ArgumentList "/norestart /q" -Wait

Write-Host "Создание адаптера Smtp Receive Adapter" -foregroundcolor "DarkCyan"
$adapterClass = [WMIClass] "root\MicrosoftBiztalkServer:MSBTS_AdapterSetting"
$adapter = $adapterClass.CreateInstance()
$adapter.Name = "Smtp Receive Adapter"
$adapter.Constraints = "6145"
$adapter.MgmtCLSID = "{95D2331F-4318-4DCA-A6D3-F0B41BBFC8F6}"
$adapter.put() | Out-Null

Write-Host "Регистрация синков" -foregroundcolor "DarkCyan"
cd "C:\Program Files\ACS\BizTalk.Adapter.Smtp\Setup\"
$content = Get-Content RegisterSink.bat
$content = $content -replace "vlgrad","$region"
Set-Content RegisterSink.bat -Value $content
Start-Process -FilePath "C:\Program Files\ACS\BizTalk.Adapter.Smtp\Setup\RegisterSink.bat" -Wait

Write-Host "Добавление групп System, Network Service и Network в группу Biztalk Usolated Host Users" -foregroundcolor "DarkCyan"
$group = [ADSI]"WinNT://SVK-GATE/Biztalk Isolated Host Users,group"
$group.add("WinNT://svk-gate/nt authority/network,group")
$group.add("WinNT://svk-gate/nt authority/network service,group")
$group.add("WinNT://svk-gate/nt authority/system,group")

Write-Host "Настройка доступа к каталогу Config" -foregroundcolor "DarkCyan"
cd "$defpath\SetAcl\"
Start-Process -FilePath "SetSMTPAccessRights.bat" -Wait

Write-Host "Регистрация схемы свойств адаптера" -foregroundcolor "DarkCyan"
cd "C:\Program Files\ACS\BizTalk.Adapter.Smtp\Setup"
Start-Process -FilePath "Deploy.bat" -Wait

Write-Host "Регистрация источников событий" -foregroundcolor "DarkCyan"
cd "$defpath\RegisterEventSource\"
Start-Process -Filepath "RegisterSMTP.bat" -Wait

Write-Host "Адаптер Smtp Receive Adapter установлен и сконфигурирован" -foregroundcolor "DarkCyan"
Write-Host "Нажмите любую клавишу для продолжения..."
$x=$host.UI.RawUI.ReadKey("NoEcho, IncludeKeyDown")
