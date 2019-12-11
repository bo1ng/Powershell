$defpath = Get-Content Path.txt

#��������� �����
Write-Host "��������� �����" -foregroundcolor "DarkCyan"
Import-Module ServerManager
Add-WindowsFeature AS-NET-Framework, AS-Ent-Services, AS-TCP-Port-Sharing, AS-Incoming-Trans, AS-Outgoing-Trans, AS-WS-Atomic
Write-Host "`n`n`n`n`n`n`n`n"

Write-Host "����� ���������� ��������, � ������� ����� ������� COM+ ����������.`n������� This User � ������������ MqsAgentUser. ��������� ��������� �������� �� ���������." -ForegroundColor "DarkYellow"
Start-Process -FilePath "C:\Program Files (x86)\Microsoft BizTalk Server 2010\MQSConfigWiz.exe"
Write-Host "����� ���������� ��������� ������� ����� �������..." -ForegroundColor "DarkYellow"
$x=$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")


Write-Host "��������� COM+ ���������� MQSAgent2" -foregroundcolor "DarkCyan"
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

Write-Host "��������� ���������� MSDTC" -ForegroundColor "DarkCyan"
Set-ItemProperty -path HKLM:\Software\Microsoft\MSDTC\Security -name XaTransactions -Value 1
Set-ItemProperty -path HKLM:\Software\Microsoft\MSDTC\Security -name NetworkDtcAccessClients -Value 1
Set-ItemProperty -path HKLM:\Software\Microsoft\MSDTC -name AllowOnlySecureRpcCalls -Value 0
Set-ItemProperty -path HKLM:\Software\Microsoft\MSDTC -name TurnOffRpcSecurity -Value 1
Set-ItemProperty -path HKLM:\Software\Microsoft\MSDTC -name FallbackToUnsecureRPCIfNecessary -Value 0

Write-Host "���������� ������� �������� ������������ WmqHostUser � ���� CreatorOwner ��� ���������� MQSAgent2 � �������� Component Services`n� ����� ��������� LocalDTC �������� Capacity Log = 512 MB" -ForegroundColor "DarkYellow"
Write-Host "������� ����� ������� ��� �����������..."
$x=$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
