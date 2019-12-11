$defpath = Get-Content Path.txt

#Установка ролей
Write-Host "Установка ролей" -foregroundcolor "DarkCyan"
Import-Module ServerManager
Add-WindowsFeature AS-NET-Framework, AS-Ent-Services, AS-TCP-Port-Sharing, AS-Incoming-Trans, AS-Outgoing-Trans, AS-WS-Atomic
Write-Host "`n`n`n`n`n`n`n`n"

Write-Host "Далее запустится оснастка, в которой нужно создать COM+ приложение.`nВыбрать This User и пользователя MqsAgentUser. Остальные параметры оставить по умолчанию." -ForegroundColor "DarkYellow"
Start-Process -FilePath "C:\Program Files (x86)\Microsoft BizTalk Server 2010\MQSConfigWiz.exe"
Write-Host "После завершения настройки нажмите любую клавишу..." -ForegroundColor "DarkYellow"
$x=$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")


Write-Host "Настройка COM+ приложения MQSAgent2" -foregroundcolor "DarkCyan"
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

$comAdmin.CreateServiceForApplication("MqsAgent2","MqsAgent2","SERVICE_AUTO_START","SERVICE_ERROR_CRITICAL","",".\MqsAgentUser","Qaz123!@#wsx",$False)

$comAdmin.ShutdownApplication("MqsAgent2")
$applications = $comAdmin.GetCollection("Applications") 
$applications.Populate() 

foreach ($application in $applications)
{
    if ($application.Name -eq "MqsAgent2")
    {
        $application.Value("Activation") = "1"
        $application.Value("Identity") = ".\MqsAgentUser"
        $application.Value("Password") = "Qaz123!@#wsx"
    }
}

$applications.SaveChanges() | Out-Null

Set-location "$defpath\Misc"
powershell.exe "$defpath\Misc\AddAccountToLogonAsService.ps1" "SVK-GATE\MqsAgentUser" | Out-Null

Start-Service MqsAgent2

Write-Host "Настройка параметров MSDTC" -ForegroundColor "DarkCyan"
Set-ItemProperty -path HKLM:\Software\Microsoft\MSDTC\Security -name XaTransactions -Value 1
Set-ItemProperty -path HKLM:\Software\Microsoft\MSDTC\Security -name NetworkDtcAccessClients -Value 1
Set-ItemProperty -path HKLM:\Software\Microsoft\MSDTC -name AllowOnlySecureRpcCalls -Value 0
Set-ItemProperty -path HKLM:\Software\Microsoft\MSDTC -name TurnOffRpcSecurity -Value 1
Set-ItemProperty -path HKLM:\Software\Microsoft\MSDTC -name FallbackToUnsecureRPCIfNecessary -Value 0

Write-Host "Необходимо вручную добавить пользователя WmqHostUser в роль CreatorOwner для приложения MQSAgent2 в оснастке Component Services`nа также настроить LocalDTC параметр Capacity Log = 512 MB" -ForegroundColor "DarkYellow"
Write-Host "Нажмите любую клавишу для продолжения..."
$x=$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
