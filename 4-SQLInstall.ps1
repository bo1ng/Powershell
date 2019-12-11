do {$path = Read-Host "Введите путь до setup.exe дистрибутива SQL Server 2008 R2 (Например D:\)"
    if ((Test-Path "$path\setup.exe") -match "false")
        {
        Write-host "В директории $path отсутствует установочный файл setup.exe" -ForegroundColor "red"
        }
    }
until ((Test-Path "$path\setup.exe") -match "true")
$defpath = Get-Content Path.txt
Write-Host "Установка SQL Server 2008 R2" -Foregroundcolor "DarkCyan"
Start-Process -Filepath "$path\setup.exe" -ArgumentList "/Q /ACTION=install /IACCEPTSQLSERVERLICENSETERMS /SAPWD=Qaz123!@#wsx /CONFIGURATIONFILE=$defpath\SQL\configurationfile.ini /INDICATEPROGRESS" -Wait
Write-Host "Установка SP3" -Foregroundcolor "DarkCyan"
Start-Process -Filepath "$defpath\SQL\SQLServer2008R2SP3-KB2979597-x64-ENU.exe" -ArgumentList "/QS /ALLINSTANCES /ACTION=Patch /IACCEPTSQLSERVERLICENSETERMS /INDICATEPROGRESS" -Wait
#Write-Host "Установка обновлений" -Foregroundcolor "DarkCyan"
#Start-Process -Filepath "$defpath\SQL\SQLServer2008R2-KB2754552-x64.exe" -ArgumentList "/Q /ACTION=Patch /IACCEPTSQLSERVERLICENSETERMS /instancename=SVK-GATE /INDICATEPROGRESS" -Wait
Write-Host "Установка завершена.Для продолжения нажмите любую клавишу..."
$x=$host.UI.RawUI.ReadKey("NoEcho, IncludeKeyDown")
