$testpath = Test-Path C:\temp
$testpathlog = Test-Path C:\temp\PortCheckerLOG.txt
$pathlog = "C:\temp\PortCheckerLOG.txt"

if ($testpath -eq $false)
    {
    New-Item C:\temp -type directory
    }

if ($testpathlog -eq $false)
    {
    New-Item $pathlog -type file
    }    

Function PortCheck ($ip, $port)
{
$date = Get-Date
$Socket = New-Object Net.Sockets.TcpClient
$ErrorActionPreference = 'SilentlyContinue'
$Socket.Connect($ip, $port)
if ($Socket.connected)
    {
#    Write-host "Соединение установлено" -ForegroundColor green
    $Socket.Close()
    }
        else
        {Write-host "$ip $port Соединение не установлено" -ForegroundColor red
        #Следующая строка это логирования. Отключить решеткой, если не нужно.
         Add-Content  $pathlog "$date $ip $port Соединение не установлено"
         
            $PlayWav=New-Object System.Media.SoundPlayer
            $PlayWav.SoundLocation=’C:\Windows\Media\tada.wav’
            $PlayWav.playsync()
        }
 }
 
 while (1 -gt 0)
 {
 
 #Список проверок в формате PortCheck ipaddress port
 
  
 #Альтеоны №№1-2
 PortCheck 10.117.105.60 80
 PortCheck 10.117.105.60 443
 PortCheck 10.117.105.60 110
 PortCheck 10.117.105.60 995
 PortCheck 10.117.105.60 143
 PortCheck 10.117.105.60 993
 PortCheck 10.117.105.60 25
 PortCheck 10.117.105.60 587
 PortCheck 10.117.105.60 2526
 PortCheck 10.117.105.70 443
 
 #Альтеоны №№3-4
 PortCheck 10.117.106.60 80
 PortCheck 10.117.106.60 443
 PortCheck 10.117.106.60 110
 PortCheck 10.117.106.60 995
 PortCheck 10.117.106.60 143
 PortCheck 10.117.106.60 993
 PortCheck 10.117.106.60 25
 PortCheck 10.117.106.60 587
 PortCheck 10.117.106.60 2526
  
 #Альтеоны СА
 PortCheck 10.117.82.71 80
 PortCheck 10.117.82.71 443
 PortCheck 10.117.82.71 110
 PortCheck 10.117.82.71 995
 PortCheck 10.117.82.71 143
 PortCheck 10.117.82.71 993
 PortCheck 10.117.82.71 135
 PortCheck 10.117.82.71 59532
 PortCheck 10.117.82.71 59533
 PortCheck 10.117.82.71 6001
 
 #Альтеоны НТ
 PortCheck 10.117.82.78 25
 PortCheck 10.117.82.78 2525
 PortCheck 10.117.82.78 587
 PortCheck 10.117.82.20 25
 PortCheck 10.117.82.20 2525
 PortCheck 10.117.82.20 587
 PortCheck 10.117.82.30 25
 PortCheck 10.117.82.29 25
 PortCheck 10.117.82.29 10090
 
 
 
 #Время ожидания между опросами в секундах
 Start-Sleep -Seconds 180
 }

