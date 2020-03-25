$path = "D:\MyManuals\PowerShell\DeviceParser"
$device1 = "Системная плата"
$device2 = "Motherboard name"
$files = Get-ChildItem  -Path $path -Recurse | Where-Object {$_.Name -like "*.txt"}
$array = @()
foreach ($file in $files)
    {
        $content = Get-Content -Path $file.pspath
        foreach ($str in $content)
            {
                if ($str -match $device1 -or $str -match $device2)
                    {
                        $str = $str -replace "Системная плата",""
                        $str = $str -replace "Motherboard name",""
                        $str = $str -replace '(^\s+|\s+$)','' -replace '\s+',' '
                        if ($str -notmatch "--------" -and $str -notmatch "DMI" -and $str -notmatch "Размещение" -and $str -notmatch "Описание драйвера" -and $str -notmatch "Память" -and $str -notmatch "°C" -and $str -notmatch "5.1.2600.5512")
                        
                        {
                            $array += $str
                        }
                    }
            }
    }
$array = $array | group | select name, count | Sort-Object -Property Count -Descending | Export-Csv $path/result.csv -Delimiter ';' -Encoding "UTF8" -NoTypeInformation