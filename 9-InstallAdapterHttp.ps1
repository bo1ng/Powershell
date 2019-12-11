$region = Read-Host "������� �������� ������� (�������� - tver)"
#$path = Read-Host "������� ���� �� ������������ ACS.BizTalk.Adapter.Http.msi (������ - C:\temp\msi)"
$defpath = Get-Content Path.txt

Write-Host "��������� ACS.BizTalk.Adapter.Http" -foregroundcolor "DarkCyan"
Start-Process -filepath "$defpath\msi\ACS.BizTalk.Adapter.Http.msi" -ArgumentList "/norestart /q" -Wait

Write-Host "�������� �������� Http Receive Adapter" -foregroundcolor "DarkCyan"
$adapterClass = [WMIClass] "root\MicrosoftBiztalkServer:MSBTS_AdapterSetting"
$adapter = $adapterClass.CreateInstance()
$adapter.Name = "Http Receive Adapter"
$adapter.Constraints = "6281"
$adapter.MgmtCLSID = "{7B759DB9-A2CE-4171-B366-0BCC8280B971}"
$adapter.put() | Out-Null

#�������� ������ �������� ������ � HostName = HttpHost ��� �������� Http Receive Adapter
Write-Host "������ � ReceiveHandler Http Receive Adapter..." -foregroundcolor "DarkCyan"
$http = Get-WmiObject MSBTS_ReceiveHandler -Namespace 'root\MicrosoftBiztalkServer'| Where-Object {$_.adaptername -match "Http Receive Adapter"}
$http.HostName = "HttpHost"
$http.put() | Out-Null

#�������� ������� �������� ������ � HostName = TrackingHost ��� �������� Http Receive Adapter
Write-Host "������ � SendHandler Http Receive Adapter..." -foregroundcolor "DarkCyan"
$d = Get-WmiObject MSBTS_ReceiveHandler -Namespace 'root\MicrosoftBiztalkServer'| Where-Object {$_.adaptername -match "Http Receive Adapter" -and $_.hostname -match "TrackingHost"}
$d.Delete() | Out-Null

#��������� �������� �������� ������
Write-Host "��������� ������� �������� - ��������� svk.$region.cbr.ru � �������� ������" -foregroundcolor "DarkCyan"
$http = Get-WmiObject MSBTS_ReceiveHandler -Namespace 'root\MicrosoftBiztalkServer' | Where-Object {$_.adaptername -match "Http Receive Adapter" -and $_.hostname -match "HttpHost"}
$http.CustomCfg = "<CustomProps><AdapterConfig vt='8'>&lt;Config xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema'&gt;&lt;realm&gt;svk.$region.cbr.ru&lt;/realm&gt;&lt;schemas&gt;Digest&lt;/schemas&gt;&lt;/Config&gt;</AdapterConfig></CustomProps>"
$http.put() | Out-Null

netsh http add urlacl url=http://*:80/ user=SVK-GATE\HttpHostUser

cd "C:\Program Files\ACS\BizTalk.Adapter.Http\Sql"
Write-Host "�������� ���� ������ SvkSegmentation" -foregroundcolor "DarkCyan"
Start-Process -Filepath 'C:\Program Files\ACS\BizTalk.Adapter.Http\Sql\SVkSegmentation.bat' -wait
Write-Host "�������� ������� ��� ���� ������ SvkSegmentation" -foregroundcolor "DarkCyan"
Start-Process -Filepath 'C:\Program Files\ACS\BizTalk.Adapter.Http\Sql\SVkSegmentation_Job.bat' -wait

Write-Host "����������� Http ��������" -foregroundcolor "DarkCyan"
cd "$defpath\RegisterEventSource\"
Start-Process -Filepath "RegisterHTTP.bat" -Wait

Write-Host "������� Http Receive Adapter ���������� � ���������������" -foregroundcolor "DarkCyan"
Write-Host "������� ����� ������� ��� �����������..."
$x=$host.UI.RawUI.ReadKey("NoEcho, IncludeKeyDown")
