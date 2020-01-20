$region = Read-Host "Ââåäèòå èìÿ ðåãèîíà ÁÎËÜØÈÌÈ ÁÓÊÂÀÌÈ"
$AdIp = Read-Host "Ââåäèòå IP-àäðåñ êîíòðîëëåðà äîìåíà, íà êîòîðîì áóäåò ñîçäàíà îáùåäîñòóïíàÿ äèðåêòîðèÿ SDKSHARE"

Write-Host "Êîïèðîâàíèå ôàéëîâ" -ForegroundColor "DarkCyan"
$defpath = Get-Content Path.txt
Copy-Item -Path "$defpath\Msi\ACS\KAVSDK Install\1)KAVSDK\" -Recurse -Destination "C:\KAVSDK"

Write-Host "Ðåäàêòèðîâàíèå ôàéëà kavservice.xml" -ForegroundColor "DarkCyan"
$content = Get-Content "C:\KAVSDK\bin\kavservice.xml"
$content = $content -replace "RU.CBR.*.SVK.INTGATE","RU.CBR.$region.SVK.INTGATE"
Set-Content "C:\KAVSDK\bin\kavservice.xml" -Value $content

Write-Host "Óñòàíîâêà è íàñòðîéêà ñëóæáû Kavservice" -ForegroundColor "DarkCyan"
Set-Location "C:\KAVSDK\"
Start-Process -FilePath "C:\KAVSDK\ServiceInstall.bat" -Wait
$service = gwmi win32_service -filter "name='Kavservice'"
$service.change($null,$null,$null,$null,$null,$null,"SVK\kavservice","password") | Out-Null
Set-Service Kavservice -StartupType "Automatic" | Out-Null

Write-Host "Íàçíà÷åíèå ïðàâà Logon As Service äëÿ ó÷åòíîé çàïèñè SVK\kavservice" -ForegroundColor "DarkCyan" 
Set-location "$defpath\Misc"
powershell.exe "$defpath\Misc\AddAccountToLogonAsService.ps1" "SVK\kavservice" | Out-Null

Write-Host "Íàçíà÷åíèå ïðàâ íà îáúåêòû WMQ äëÿ ó÷åòíûõ çàïèñåé ExternalHostUser è kavservice" -ForegroundColor "DarkCyan"
$QMGR = "RU.CBR.$region.SVK.INTGATE"
setmqaut -m $QMGR -t qmgr -p ExternalHostUser -all | Out-Null
setmqaut -m $QMGR -t qmgr -p ExternalHostUser +chg +dlt +dsp +setall +setid +altusr +connect +inq +set +system | Out-Null
setmqaut -m $QMGR -t qmgr -p kavservice -all | Out-Null
setmqaut -m $QMGR -t qmgr -p kavservice +chg +dlt +dsp +setall +setid +altusr +connect +inq +set +system | Out-Null
setmqaut -m $QMGR -n "KAV.FROM" -t q -p ExternalHostUser -remove | Out-Null
setmqaut -m $QMGR -n "KAV.FROM" -t q -p ExternalHostUser +chg +clr +dlt +dsp +passall +passid +setall +setid +browse +get +inq +put +set | Out-Null
setmqaut -m $QMGR -n "KAV.FROM" -t q -p kavservice -remove | Out-Null
setmqaut -m $QMGR -n "KAV.FROM" -t q -p kavservice +chg +clr +dlt +dsp +passall +passid +setall +setid +browse +get +inq +put +set | Out-Null
setmqaut -m $QMGR -n "KAV.TO" -t q -p ExternalHostUser -remove | Out-Null
setmqaut -m $QMGR -n "KAV.TO" -t q -p ExternalHostUser +chg +clr +dlt +dsp +passall +passid +setall +setid +browse +get +inq +put +set | Out-Null
setmqaut -m $QMGR -n "KAV.TO" -t q -p kavservice -remove | Out-Null
setmqaut -m $QMGR -n "KAV.TO" -t q -p kavservice +chg +clr +dlt +dsp +passall +passid +setall +setid +browse +get +inq +put +set | Out-Null
setmqaut -m $QMGR -n "KAV.CONTROL" -t chl -p ExternalHostUser -remove | Out-Null
setmqaut -m $QMGR -n "KAV.CONTROL" -t chl -p ExternalHostUser +chg +dlt +dsp +ctrl +ctrlx | Out-Null
setmqaut -m $QMGR -n "KAV.CONTROL" -t chl -p kavservice -remove | Out-Null
setmqaut -m $QMGR -n "KAV.CONTROL" -t chl -p kavservice +chg +dlt +dsp +ctrl +ctrlx | Out-Null
setmqaut -m $QMGR -n "KAV.CONTROL.LISTENER" -t listener -p ExternalHostUser -remove
setmqaut -m $QMGR -n "KAV.CONTROL.LISTENER" -t listener -p ExternalHostUser +chg +dlt +dsp +ctrl
setmqaut -m $QMGR -n "KAV.CONTROL.LISTENER" -t listener -p kavservice -remove
setmqaut -m $QMGR -n "KAV.CONTROL.LISTENER" -t listener -p kavservice +chg +dlt +dsp +ctrl



Write-Host "Äîáàâëåíèå ó÷åòíîé çàïèñè ExternalHostUser â ãðóïïó mqm" -ForegroundColor "DarkCyan"
$group = [ADSI]"WinNT://SVK-GATE/mqm,group"
$group.add("WinNT://svk-gate/ExternalHostUser,user")

Write-Host "Óäàëåíèå ñòàðûõ êëþ÷åé" -ForegroundColor "DarkCyan"
$keys = Get-ChildItem "C:\KAVSDK\bin" | Where-Object {$_.name -like "*.key"}
foreach ($key in $keys)
{
    if ($key.name -like "*.key")
    {
        Remove-Item "C:\KAVSDK\bin\$key"
    }
}

Write-Host "Óñòàíîâêà ïàò÷à" -ForegroundColor "DarkCyan"
Copy-Item "$defpath\Msi\ACS\KAVSDK Install\2)Patch 1 KAVSDK\Patch 1 KAVSDK\*" -Recurse -Destination "C:\KAVSDK\bin\" -force

Write-Host "Ðåäàêòèðîâàíèå ôàéëà kavservice.xml" -ForegroundColor "DarkCyan"
$content = Get-Content "C:\KAVSDK\bin\kavservice.xml"
$content = $content -replace "RU.CBR.*.SVK.INTGATE","RU.CBR.$region.SVK.INTGATE"
Set-Content "C:\KAVSDK\bin\kavservice.xml" -Value $content

Write-Host "Ïîäãîòîâêà ñëóæáû ê çàïóñêó" -ForegroundColor "DarkCyan"
Set-Location "C:\KAVSDK\bin"
Start-Process "C:\KAVSDK\bin\kavecscan.exe" -ArgumentList "cab.ppl" -wait
Start-Service Kavservice

Write-Host "Íàñòðîéêà îáíîâëåíèÿ KAVSDK" -ForegroundColor "DarkCyan"
Copy-item "$defpath\Msi\ACS\KAVSDK Install\3)Updater_SDK\*" -Recurse -Destination "C:\KAVSDK\" -Force

$content = Get-Content "C:\KAVSDK\Updater_SDK\GateWay_settings_retranslation.xml"
$content = $content -replace "AdIp","$AdIp"
Set-Content "C:\KAVSDK\Updater_SDK\GateWay_settings_retranslation.xml" -Value $content

Write-Host "Óñòàíîâêà vcredist_x86_2010.exe" -ForegroundColor "DarkCyan"
Start-Process "$defpath\Msi\ACS\KAVSDK Install\4)sdk_KASPERSKY\_1\vcredist_x86_2010.exe" -ArgumentList "/quiet" -wait

Write-Host "Óñòàíîâêà ïàêåòà ìîäèôèêàöèé" -ForegroundColor "DarkCyan"
Stop-Service Kavservice

do {
    Start-Sleep -Seconds 2    
   }
while ((get-service kavservice).status -ne "Stopped")


Copy-Item "$defpath\Msi\ACS\KAVSDK Install\4)sdk_KASPERSKY\_1\kavlog.properties" -Destination "C:\KAVSDK\bin\" -Force
Copy-Item "$defpath\Msi\ACS\KAVSDK Install\4)sdk_KASPERSKY\_1\kavservice.exe" -Destination "C:\KAVSDK\bin\" -Force
Copy-Item "$defpath\Msi\ACS\KAVSDK Install\4)sdk_KASPERSKY\_1\log4cplus.dll" -Destination "C:\KAVSDK\bin\" -Force
       
New-Item "C:\KAVSDK\logs" -Type Directory | Out-Null

Write-Host "Íåîáõîäèìî ñîçäàòü îáùåäîñòóïíóþ äèðåêòîðèþ C:\SDKSHARE íà êîíòðîëëåðå äîìåíà." -ForegroundColor "DarkYellow"
Write-Host "Âñå îïåðàöèè çàâåðøåíû. Äëÿ ïåðåçàãðóçêè íàæìèòå ëþáóþ êëàâèøó..." -foregroundcolor "DarkCyan"
$x=$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
Restart-Computer
