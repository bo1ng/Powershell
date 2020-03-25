$n = 0
while ($n -lt 1)
{
#Partner host is B. He have 2 ipaddreses - B_1 and B_2
$ipaddr_B_1 = "192.168.0.2"
$ipaddr_B_2 = "10.0.0.2"
$ipaddr = ""

$hostspath = "C:\Windows\system32\drivers\etc\hosts"
$hosts = Get-Content -Path $hostspath
if ($hosts -like "$ipaddr_B_1*")
    {$ipaddr = "$ipaddr_B_1"}
elseif ($hosts -like "$ipaddr_B_2*")
    {$ipaddr = $ipaddr_B_2}

Write-Host $ipaddr


if ((Test-Connection -ComputerName $ipaddr -Quiet -Count 4) -eq $false)
    {
        Write-Host "NO PING"
        if ($ipaddr -eq $ipaddr_B_1)
        {
            $newhosts = $hosts -replace "$ipaddr_B_1","$ipaddr_B_2"
            Set-Content -Path $hostspath -Value $newhosts
        }
        elseif ($ipaddr -eq $ipaddr_B_2)
        {
          $newhosts = $hosts -replace "$ipaddr_B_2","$ipaddr_B_1"
          Set-Content -Path $hostspath -Value $newhosts  
        }
    }
    Start-Sleep -Seconds 5
}