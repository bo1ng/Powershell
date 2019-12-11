$region = Read-Host "Введите название имя региона (пример - tver)"

#Переименование домена по умолчанию
$virt = get-wmiobject IISSmtpServerSetting -namespace root/MicrosoftIISv2 | Where-Object {$_.Name -match "1"}
$virt.defaultDomain = "ext-gate.svk.$region.cbr.ru"
$virt.FullyQualifiedDomainName = "ext-gate.svk.$region.cbr.ru"
$virt.Put() | Out-Null

#Получение IP-адреса
$ip = Get-WmiObject Win32_NetworkAdapterConfiguration | ? {$_.ipenabled}
$Ip1 = $ip.ipaddress[0]
$Ip2 = $ip.ipaddress[1]
$readip = Read-Host "На сетевом адаптере назначено два IP.`n1)$ip1`n2)$ip2`nКакой использовать для домена FromKBR?(Введите номер и нажмите Enter)"
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
Write-Host "Для домена FromKbr будет использован IP $IpFromKbr" -ForegroundColor "DarkYellow"
Write-Host "Для домена FromIas будет использован IP $IpFromIas" -ForegroundColor "DarkYellow"

#Настройка IP-адреса для сервера FromKbr
Write-Host "Настройка IP-адреса для сервера FromKbr" -ForegroundColor "DarkCyan"
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

#Создание Alias домена mdn.receipt.ext-gate.svk.$region.cbr.ru
Write-Host "Создание Alias домена mdn.receipt.ext-gate.svk.$region.cbr.ru" -ForegroundColor "DarkCyan"
$smtpDomains = [wmiclass]'root\MicrosoftIISv2:IIsSmtpDomain'
$newSMTPDomain = $smtpDomains.CreateInstance()
$newSMTPDomain.Name = "SmtpSvc/1/Domain/mdn.receipt.ext-gate.svk.$region.cbr.ru"
$newSMTPDomain.put() | Out-Null

$smtpDomainSettings = [wmiclass]'root\MicrosoftIISv2:IIsSmtpDomainSetting'
$newsmtpDomainSettings = $smtpDomainSettings.CreateInstance()
$newsmtpDomainSettings.RouteAction = 16
$newsmtpDomainSettings.name = "SmtpSvc/1/Domain/mdn.receipt.ext-gate.svk.$region.cbr.ru"
$newsmtpDomainSettings.put() | Out-Null

#Настройка Authentication и Limits
Write-Host "Настройка Authentication и Limits для FromKBR" -ForegroundColor "DarkCyan"
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

Write-Host "Далее необходимо открыть IIS 6.0 Manager и создать новый SMTP-сервер c параметрами`nИмя FromIAS `nДомен int-gate.svk.$region.cbr.ru `nIP адрес $IpFromIAS`nДомашняя директория C:\inetpub\FromIAS`nПосле создания нажмите любую клавишу..." -foregroundcolor "DarkYellow"
$x=$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")


#Создание Alias домена mdn.receipt.int-gate.svk.$region.cbr.ru
Write-Host "Создание Alias домена mdn.receipt.int-gate.svk.$region.cbr.ru" -ForegroundColor "DarkCyan"
$smtpDomains = [wmiclass]'root\MicrosoftIISv2:IIsSmtpDomain'
$newSMTPDomain = $smtpDomains.CreateInstance()
$newSMTPDomain.Name = "SmtpSvc/2/Domain/mdn.receipt.int-gate.svk.$region.cbr.ru"
$newSMTPDomain.put() | Out-Null

$smtpDomainSettings = [wmiclass]'root\MicrosoftIISv2:IIsSmtpDomainSetting'
$newsmtpDomainSettings = $smtpDomainSettings.CreateInstance()
$newsmtpDomainSettings.RouteAction = 16
$newsmtpDomainSettings.name = "SmtpSvc/2/Domain/mdn.receipt.int-gate.svk.$region.cbr.ru"
$newsmtpDomainSettings.put() | Out-Null


#Настройка Authentication и Limits для FromIAS
Write-Host "Настройка Authentication и Limits " -ForegroundColor "DarkCyan"
$obj = get-wmiobject IISSmtpServerSetting -namespace root\MicrosoftIISv2 | Where-Object {$_.Name -match "2"}
$obj.MaxMessageSize = 52428800
$obj.MaxSessionSize = 0
$obj.MaxBatchedMessages = 0
$obj.MaxRecipients = 0
$obj.routeaction = 8388609
$obj.put() | Out-Null

Write-Host "Настройка IIS SMTP Server завершена." -foregroundcolor "DarkCyan"
Write-Host "Нажмите любую клавишу для продолжения..."
$x=$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
