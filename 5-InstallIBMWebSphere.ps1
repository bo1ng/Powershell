$defpath = Get-Content Path.txt
do {$IESpath = Read-Host "Введите путь до дистрибутива WebSphere Eclipse Platform (пример - D:\Prereqs\IES\MSI)"
    if ((Test-Path "$IESpath\IBM WebSphere Eclipse Platform V3.3.msi") -match "false")
        {
        Write-host "В директории $path отсутствует установочный файл IBM WebSphere Eclipse Platform V3.3.msi" -ForegroundColor "red"
        }
    }
until ((Test-Path "$IESpath\IBM WebSphere Eclipse Platform V3.3.msi") -match "true")
Set-Location $iespath
Write-Host "Установка платформы WebSphere MQ Eclipse Platform" -ForegroundColor "DarkCyan"
Start-Process -FilePath "IBM WebSphere Eclipse Platform V3.3.msi" -ArgumentList "/PASSIVE" -Wait

do {$path = Read-Host "Введите путь до msi-файла WebSphere MQ (пример - D:\MSI)"
    if ((Test-Path "$path\IBM WebSphere MQ.msi") -match "false")
        {
            Write-Host "В директории $path отсутствует установочный файл IBM WebSphere MQ.msi" -ForegroundColor "red"
        }
    }
until ((Test-Path "$path\IBM WebSphere MQ.msi") -match "true")
Set-Location $path
Write-Host "Установка IBM WebSphere MQ 7.0" -ForegroundColor "DarkCyan"
Start-Process -FilePath "IBM WebSphere MQ.msi" -ArgumentList "/PASSIVE USEINI=$defpath\MQ\conf.ini" -Wait

cd "$defpath\MQ\WebSphere MQ 7.0.1.13 EnUs"
Write-Host "Установка обновления WebSphere MQ 7.0.1.13" -ForegroundColor "DarkCyan"
Start-Process -FilePath "install.bat" -wait
Write-Host "Установка обновления до версии 7.0.1.13 завершена. Нажмите любую клавишу для продолжения..."

$x=$host.UI.RawUI.ReadKey("NoEcho, IncludeKeyDown")
