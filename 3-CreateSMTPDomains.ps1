$region = Read-Host "������� �������� ��� ������� (������ - tver)"

#�������������� ������ �� ���������
$virt = get-wmiobject IISSmtpServerSetting -namespace root/MicrosoftIISv2 | Where-Object {$_.Name -match "1"}
$virt.defaultDomain = "ext-gate.svk.$region.cbr.ru"
$virt.FullyQualifiedDomainName = "ext-gate.svk.$region.cbr.ru"
$virt.Put() | Out-Null

#��������� IP-������
$ip = Get-WmiObject Win32_NetworkAdapterConfiguration | ? {$_.ipenabled}
$Ip1 = $ip.ipaddress[0]
$Ip2 = $ip.ipaddress[1]
$readip = Read-Host "�� ������� �������� ��������� ��� IP.`n1)$ip1`n2)$ip2`n����� ������������ ��� ������ FromKBR?(������� ����� � ������� Enter)"
$IpFromKbr = $ip.ipaddress[$readip-1]
if ($IpFromKBR -eq $ip1)
    {
        $IpFromIas = $ip2
    }
    else{ 
        if ($IpFromKBR -eq $ip2)
            {
                $IpFromIAS = $ip1
            }
        }
Write-Host "��� ������ FromKbr ����� ����������� IP $IpFromKbr" -ForegroundColor "DarkYellow"
Write-Host "��� ������ FromIas ����� ����������� IP $IpFromIas" -ForegroundColor "DarkYellow"

#��������� IP-������ ��� ������� FromKbr
Write-Host "��������� IP-������ ��� ������� FromKbr" -ForegroundColor "DarkCyan"
$port = "25"
$hostname = ""
$obj = get-wmiobject IISSmtpServerSetting -namespace root\MicrosoftIISv2 | Where-Object {$_.Name -match "1"}
$bindings = $obj.ServerBindings
foreach ($binding in $bindings)
{
	$binding.IP = $IpFromKbr
	$binding.Port = $port
	$binding.Hostname = $hostname
}
$obj.ServerBindings = $bindings
$obj.put() | Out-Null

#�������� Alias ������ mdn.receipt.ext-gate.svk.$region.cbr.ru
Write-Host "�������� Alias ������ mdn.receipt.ext-gate.svk.$region.cbr.ru" -ForegroundColor "DarkCyan"
$smtpDomains = [wmiclass]'root\MicrosoftIISv2:IIsSmtpDomain'
$newSMTPDomain = $smtpDomains.CreateInstance()
$newSMTPDomain.Name = "SmtpSvc/1/Domain/mdn.receipt.ext-gate.svk.$region.cbr.ru"
$newSMTPDomain.put() | Out-Null

$smtpDomainSettings = [wmiclass]'root\MicrosoftIISv2:IIsSmtpDomainSetting'
$newsmtpDomainSettings = $smtpDomainSettings.CreateInstance()
$newsmtpDomainSettings.RouteAction = 16
$newsmtpDomainSettings.name = "SmtpSvc/1/Domain/mdn.receipt.ext-gate.svk.$region.cbr.ru"
$newsmtpDomainSettings.put() | Out-Null

#��������� Authentication � Limits
Write-Host "��������� Authentication � Limits ��� FromKBR" -ForegroundColor "DarkCyan"
$obj = get-wmiobject IISSmtpServerSetting -namespace root\MicrosoftIISv2 | Where-Object {$_.Name -match "1"}
$obj.ServerComment = "FromKBR"
$obj.AuthAnonymous = "false"
$obj.AuthBasic = "true"
$obj.AuthFlags = 2
$obj.SaslLogonDomain = "svk.$region.cbr.ru"
$obj.MaxMessageSize = 52428800
$obj.MaxSessionSize = 0
$obj.MaxBatchedMessages = 0
$obj.MaxRecipients = 0
$obj.routeaction = 8388609
$obj.put() | Out-Null

Write-Host "����� ���������� ������� IIS 6.0 Manager � ������� ����� SMTP-������ c �����������`n��� FromIAS `n����� int-gate.svk.$region.cbr.ru `nIP ����� $IpFromIAS`n�������� ���������� C:\inetpub\FromIAS`n����� �������� ������� ����� �������..." -foregroundcolor "DarkYellow"
$x=$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")


#�������� Alias ������ mdn.receipt.int-gate.svk.$region.cbr.ru
Write-Host "�������� Alias ������ mdn.receipt.int-gate.svk.$region.cbr.ru" -ForegroundColor "DarkCyan"
$smtpDomains = [wmiclass]'root\MicrosoftIISv2:IIsSmtpDomain'
$newSMTPDomain = $smtpDomains.CreateInstance()
$newSMTPDomain.Name = "SmtpSvc/2/Domain/mdn.receipt.int-gate.svk.$region.cbr.ru"
$newSMTPDomain.put() | Out-Null

$smtpDomainSettings = [wmiclass]'root\MicrosoftIISv2:IIsSmtpDomainSetting'
$newsmtpDomainSettings = $smtpDomainSettings.CreateInstance()
$newsmtpDomainSettings.RouteAction = 16
$newsmtpDomainSettings.name = "SmtpSvc/2/Domain/mdn.receipt.int-gate.svk.$region.cbr.ru"
$newsmtpDomainSettings.put() | Out-Null


#��������� Authentication � Limits ��� FromIAS
Write-Host "��������� Authentication � Limits " -ForegroundColor "DarkCyan"
$obj = get-wmiobject IISSmtpServerSetting -namespace root\MicrosoftIISv2 | Where-Object {$_.Name -match "2"}
$obj.MaxMessageSize = 52428800
$obj.MaxSessionSize = 0
$obj.MaxBatchedMessages = 0
$obj.MaxRecipients = 0
$obj.routeaction = 8388609
$obj.put() | Out-Null

Write-Host "��������� IIS SMTP Server ���������." -foregroundcolor "DarkCyan"
Write-Host "������� ����� ������� ��� �����������..."
$x=$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
