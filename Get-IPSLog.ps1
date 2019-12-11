import-module "C:\Program Files\WindowsPowerShell\Modules\Posh-SSH"
$logdirectory = "C:\IPSLog"
$testpath = Test-Path $logdirectory
if ($TestPath -match "false")
     {New-Item C:\IPSLog -type directory
     Write-host "Создана директория $logdirectory"}
$IPSAddress = "192.168.151.3"
#$user = "cisco"
#$pass = "Qaz123!@#wsx"
$user = Read-Host "Введите имя пользователя"
$securedpass = Read-Host "Введите пароль" -AsSecureString
$bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($securedpass)
$pass = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)
$time = Read-Host "Введите время, начиная с которого нужно получить лог и нажмите Enter (hh:mm)"
$date = Read-Host "Введите дату месяца, начиная с которой нужно получить лог и нажмите Enter (1 или 2 и т.д.)"
$month = Read-Host "Введите месяц, начиная с которого нужно получить лог и нажмите Enter (1 или 2 и т.д.)"
if ($month -eq "1") {$monthl = "january"}
if ($month -eq "2") {$monthl = "february"}
if ($month -eq "3") {$monthl = "march"}
if ($month -eq "4") {$monthl = "april"}
if ($month -eq "5") {$monthl = "may"}
if ($month -eq "6") {$monthl = "june"}
if ($month -eq "7") {$monthl = "july"}
if ($month -eq "8") {$monthl = "august"}
if ($month -eq "9") {$monthl = "september"}
if ($month -eq "10") {$monthl = "october"}
if ($month -eq "11") {$monthl = "november"}
if ($month -eq "12") {$monthl = "december"}

$year = Read-Host "Введите год, начиная с которого нужно получить лог и нажмите Enter (например, 2017)"
$secpasswd = convertto-securestring $pass -AsPlainText -Force
$creds = New-Object System.Management.Automation.PSCredential ($user,$secpasswd)
New-sshsession -computername $IPSAddress -Credential $creds
$SSHSession = Get-SSHSession -index 0
$SSH = $SSHSession | New-SSHShellStream
$SSH.WriteLine("terminal length 0")
$SSH.WriteLine("show events $time $monthl $date $year")
start-sleep -Seconds 60
$log = $ssh.read()
$SSH.WriteLine("terminal length 24")
$SSH.WriteLine("exit")
Remove-SSHSession $SSHSession
$log | Out-File $logdirectory\$date-$month-$year-log.txt
Write-Host "Лог $date-$month-$year-log.txt успешно сохранен в директории $logdirectory"
Write-Host "Нажмите любую клавишу для выхода..."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")