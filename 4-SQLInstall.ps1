do {$path = Read-Host "Ââåäèòå ïóòü äî setup.exe äèñòðèáóòèâà SQL Server 2008 R2 (Íàïðèìåð D:\)"
    if ((Test-Path "$path\setup.exe") -match "false")
        {
        Write-host "Â äèðåêòîðèè $path îòñóòñòâóåò óñòàíîâî÷íûé ôàéë setup.exe" -ForegroundColor "red"
        }
    }
until ((Test-Path "$path\setup.exe") -match "true")
$defpath = Get-Content Path.txt
Write-Host "Óñòàíîâêà SQL Server 2008 R2" -Foregroundcolor "DarkCyan"
Start-Process -Filepath "$path\setup.exe" -ArgumentList "/Q /ACTION=install /IACCEPTSQLSERVERLICENSETERMS /SAPWD=password /CONFIGURATIONFILE=$defpath\SQL\configurationfile.ini /INDICATEPROGRESS" -Wait
Write-Host "Óñòàíîâêà SP3" -Foregroundcolor "DarkCyan"
Start-Process -Filepath "$defpath\SQL\SQLServer2008R2SP3-KB2979597-x64-ENU.exe" -ArgumentList "/QS /ALLINSTANCES /ACTION=Patch /IACCEPTSQLSERVERLICENSETERMS /INDICATEPROGRESS" -Wait
#Write-Host "Óñòàíîâêà îáíîâëåíèé" -Foregroundcolor "DarkCyan"
#Start-Process -Filepath "$defpath\SQL\SQLServer2008R2-KB2754552-x64.exe" -ArgumentList "/Q /ACTION=Patch /IACCEPTSQLSERVERLICENSETERMS /instancename=SVK-GATE /INDICATEPROGRESS" -Wait
Write-Host "Óñòàíîâêà çàâåðøåíà.Äëÿ ïðîäîëæåíèÿ íàæìèòå ëþáóþ êëàâèøó..."
$x=$host.UI.RawUI.ReadKey("NoEcho, IncludeKeyDown")
