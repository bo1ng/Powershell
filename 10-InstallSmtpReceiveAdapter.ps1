#$path = Read-Host "������� ���� �� ������������ ACS.BizTalk.Adapter.Http.msi (������ - C:\Scripts\msi)"
$defpath = Get-Content Path.txt
$region = Read-Host "������� ��� �������"

Write-Host "��������� ACS.BizTalk.Adapter.Smtp" -foregroundcolor "DarkCyan"
Start-Process -filepath "$defpath\msi\ACS.BizTalk.Adapter.Smtp.msi" -ArgumentList "/norestart /q" -Wait

Write-Host "�������� �������� Smtp Receive Adapter" -foregroundcolor "DarkCyan"
$adapterClass = [WMIClass] "root\MicrosoftBiztalkServer:MSBTS_AdapterSetting"
$adapter = $adapterClass.CreateInstance()
$adapter.Name = "Smtp Receive Adapter"
$adapter.Constraints = "6145"
$adapter.MgmtCLSID = "{95D2331F-4318-4DCA-A6D3-F0B41BBFC8F6}"
$adapter.put() | Out-Null

Write-Host "����������� ������" -foregroundcolor "DarkCyan"
cd "C:\Program Files\ACS\BizTalk.Adapter.Smtp\Setup\"
$content = Get-Content RegisterSink.bat
$content = $content -replace "vlgrad","$region"
Set-Content RegisterSink.bat -Value $content
Start-Process -FilePath "C:\Program Files\ACS\BizTalk.Adapter.Smtp\Setup\RegisterSink.bat" -Wait

Write-Host "���������� ����� System, Network Service � Network � ������ Biztalk Usolated Host Users" -foregroundcolor "DarkCyan"
$group = [ADSI]"WinNT://SVK-GATE/Biztalk Isolated Host Users,group"
$group.add("WinNT://svk-gate/nt authority/network,group")
$group.add("WinNT://svk-gate/nt authority/network service,group")
$group.add("WinNT://svk-gate/nt authority/system,group")

Write-Host "��������� ������� � �������� Config" -foregroundcolor "DarkCyan"
cd "$defpath\SetAcl\"
Start-Process -FilePath "SetSMTPAccessRights.bat" -Wait

Write-Host "����������� ����� ������� ��������" -foregroundcolor "DarkCyan"
cd "C:\Program Files\ACS\BizTalk.Adapter.Smtp\Setup"
Start-Process -FilePath "Deploy.bat" -Wait

Write-Host "����������� ���������� �������" -foregroundcolor "DarkCyan"
cd "$defpath\RegisterEventSource\"
Start-Process -Filepath "RegisterSMTP.bat" -Wait

Write-Host "������� Smtp Receive Adapter ���������� � ���������������" -foregroundcolor "DarkCyan"
Write-Host "������� ����� ������� ��� �����������..."
$x=$host.UI.RawUI.ReadKey("NoEcho, IncludeKeyDown")
