$path = "D:\MyManuals\PowerShell\DeviceParser"
$crypto = "Криптопро"
$kod = "Код безопасности"
$pc = "Имя NetBIOS               Логический"
$files = Get-ChildItem  -Path $path -Recurse | Where-Object {$_.Name -like "*.txt"}
$array = @()
$item = New-Object PSObject
$item | Add-Member -type NoteProperty -Name 'Hostname' -Value "$pcname"
$item | Add-Member -type NoteProperty -Name 'SKZI' -Value "$skzi"
foreach ($file in $files)
    {
        $content = Get-Content -Path $file.pspath
        foreach ($str in $content)
            {
                if ($str -match $pc)
                    {
                        $newstr = $str -replace $pc,""
                        $newstr = $newstr -replace '(^\s+|\s+$)','' -replace '\s+',' '
                        $pcname = $newstr
                        foreach ($str in $content)
                            {
                                if ($str -match $crypto -or $str -match $kod)
                                    {
                                        $item = New-Object PSObject
                                        $item | Add-Member -type NoteProperty -Name 'Hostname' -Value "$pcname"
                                        $item | Add-Member -type NoteProperty -Name 'SKZI' -Value "$skzi"
                                        $skzi = $str
                                        $array += $item
                                    }
                            }
                        
                    }
            }
    }

$array | ConvertTo-Csv -NoTypeInformation -Delimiter ';' | Select-Object -Skip 1 | Out-File $path/result.csv -Append -Encoding "UTF8"