$defpath = Get-Content Path.txt

#Óñòàíîâêà ðîëåé
Write-Host "Óñòàíîâêà ðîëåé" -foregroundcolor "DarkCyan"
Import-Module ServerManager
Add-WindowsFeature AS-NET-Framework, AS-Ent-Services, AS-TCP-Port-Sharing, AS-Incoming-Trans, AS-Outgoing-Trans, AS-WS-Atomic
Write-Host "`n`n`n`n`n`n`n`n"

Write-Host "Äàëåå çàïóñòèòñÿ îñíàñòêà, â êîòîðîé íóæíî ñîçäàòü COM+ ïðèëîæåíèå.`nÂûáðàòü This User è ïîëüçîâàòåëÿ MqsAgentUser. Îñòàëüíûå ïàðàìåòðû îñòàâèòü ïî óìîë÷àíèþ." -ForegroundColor "DarkYellow"
Start-Process -FilePath "C:\Program Files (x86)\Microsoft BizTalk Server 2010\MQSConfigWiz.exe"
Write-Host "Ïîñëå çàâåðøåíèÿ íàñòðîéêè íàæìèòå ëþáóþ êëàâèøó..." -ForegroundColor "DarkYellow"
$x=$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")


Write-Host "Íàñòðîéêà COM+ ïðèëîæåíèÿ MQSAgent2" -foregroundcolor "DarkCyan"
$comAdmin = New-Object -comobject COMAdmin.COMAdminCatalog
$comAdmin.ShutdownApplication("MqsAgent2")
$applications = $comAdmin.GetCollection("Applications") 
$applications.Populate() 

foreach ($application in $applications)
{
    if ($application.Name -eq "MqsAgent2")
    {
        $application.Value("Changeable") = $true   
    }
}

$applications.SaveChanges() | Out-Null

$comAdmin.StartApplication("MQSAgent2")

$comAdmin.CreateServiceForApplication("MqsAgent2","MqsAgent2","SERVICE_AUTO_START","SERVICE_ERROR_CRITICAL","",".\MqsAgentUser","password",$False)

$comAdmin.ShutdownApplication("MqsAgent2")
$applications = $comAdmin.GetCollection("Applications") 
$applications.Populate() 

foreach ($application in $applications)
{
    if ($application.Name -eq "MqsAgent2")
    {
        $application.Value("Activation") = "1"
        $application.Value("Identity") = ".\MqsAgentUser"
        $application.Value("Password") = "password"
    }
}

$applications.SaveChanges() | Out-Null

Set-location "$defpath\Misc"
powershell.exe "$defpath\Misc\AddAccountToLogonAsService.ps1" "SVK-GATE\MqsAgentUser" | Out-Null

Start-Service MqsAgent2

Write-Host "Íàñòðîéêà ïàðàìåòðîâ MSDTC" -ForegroundColor "DarkCyan"
Set-ItemProperty -path HKLM:\Software\Microsoft\MSDTC\Security -name XaTransactions -Value 1
Set-ItemProperty -path HKLM:\Software\Microsoft\MSDTC\Security -name NetworkDtcAccessClients -Value 1
Set-ItemProperty -path HKLM:\Software\Microsoft\MSDTC -name AllowOnlySecureRpcCalls -Value 0
Set-ItemProperty -path HKLM:\Software\Microsoft\MSDTC -name TurnOffRpcSecurity -Value 1
Set-ItemProperty -path HKLM:\Software\Microsoft\MSDTC -name FallbackToUnsecureRPCIfNecessary -Value 0

Write-Host "Íåîáõîäèìî âðó÷íóþ äîáàâèòü ïîëüçîâàòåëÿ WmqHostUser â ðîëü CreatorOwner äëÿ ïðèëîæåíèÿ MQSAgent2 â îñíàñòêå Component Services`nà òàêæå íàñòðîèòü LocalDTC ïàðàìåòð Capacity Log = 512 MB" -ForegroundColor "DarkYellow"
Write-Host "Íàæìèòå ëþáóþ êëàâèøó äëÿ ïðîäîëæåíèÿ..."
$x=$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
