do {$path = Read-Host "������� ���� �� setup.exe ������������ Biztalk Server 2010 (�������� D:\Biztalk Server)"
    if ((Test-path "$path\setup.exe") -match "false")
        {
            Write-Host "� ���������� $path ����������� ������������ ���� setup.msi" -ForegroundColor "red"
        }
    }
until ((Test-path "$path\setup.exe") -match "true" )
$defpath = Get-Content Path.txt
Write-Host "��������� Microsoft Biztalk Server 2010" -Foregroundcolor "DarkCyan"
Start-Process -Filepath "$path\setup.exe" -ArgumentList "/PASSIVE /ADDLOCAL Documentation,BizTalk,WMI,Runtime,Engine,MOT,MSMQ,AdminAndMonitoring,AdminTools,MonitoringAndTracking,BizTalkAdminSnapIn,BAMTools,PAM,WCFAdapter,WcfAdapterAdminTools,AdditionalApps,SSOAdmin,SSOServer,MQSeriesAgent /CABPATH $defpath\CAB\Bts2010Win2K8R2EN64.cab" -Wait
Write-Host "��������� ���������� Microsoft Biztalk Server 2010" -Foregroundcolor "DarkCyan"
Start-Process -FIlepath "$defpath\CAB\BizTalk2010-CU9-KB3136004-ENU.exe" -ArgumentList "/passive" -Wait
Write-Host "��������� ���������� ���������.��� ����������� ������� ����� �������..." -ForegroundColor "DarkCyan"

$defpath = Get-Content Path.txt
cd "$defpath\BtConfiguration"
#�������� ������������� UsersBts
Write-Host "�������� �������������" -foregroundcolor "DarkCyan"
Write-Host  "SsoUser `nTrackingHostUser `nIsolatedHostUser"
Start-Process -Filepath "CreateUsersBts.bat" -wait

#������ Biztalk Server COnfiguration
Start-Process -FilePath "C:\Program Files (x86)\Microsoft BizTalk Server 2010\Configuration.exe"
Write-Host "��������� ���������������� Biztalk Server (����� Custom, ����� ������ Import Configuration � ������� ����������� ������ � ������ Apply Configuration.)" -foregroundcolor "DarkYellow"
Write-host "�� ���������� ��������� ������� ����� �������..." -ForegroundColor "DarkYellow"
$x=$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

#�������� ������������� UserHost
Write-Host "�������� �������������"  -foregroundcolor "DarkCyan"
Write-Host "InternalHostUser `nExternalHostUser `nHttpHostUser `nSmtpHostUser `nWmqHostUser"
Start-Process -Filepath "CreateUsersHosts.bat" -Wait

#�������� ������������ MqsAgentUser
Write-Host "�������� ������������ MqsAgentUser"  -foregroundcolor "DarkCyan"
Start-Process -Filepath "CreateUserMqsAgent.bat" -Wait

#�������� ������
Write-Host "�������� ������" -foregroundcolor "DarkCyan"
Write-Host "ExternalHost `nInternalHost `nWmqHost `nSmtpHost `nHttpHost"
Start-Process -Filepath "CreateHosts.bat" -Wait

#�������� ����������� ������
Write-Host "�������� ����������� ������" -foregroundcolor "DarkCyan"
Write-Host "ExternalHost Instance `nInternalHost Instance `nWmqHost Instance `nSmtpHost Instance `nHttpHost Instance"
Start-Process -Filepath "CreateHostInstances.bat" -Wait

#��������� ����� �� StartType "DelayedAuto"
Write-Host "��������� ����� �� StartType DelayedAuto" -foregroundcolor "DarkCyan"
get-service BTSSvc* | foreach-object -process { sc.exe config $_.Name start= delayed-auto}
Write-Host "�� �������� ������������� ���������� � SVK" -foregroundcolor "DarkYellow"
Write-Host "��������� ���������. ������� ����� ������� ��� ������������..." -foregroundcolor "DarkCyan"
$x=$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
Restart-Computer
