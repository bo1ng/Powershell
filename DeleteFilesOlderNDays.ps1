$dir = "C:\temp\*"
$days = 200
$files = Get-ChildItem $dir -Recurse
$now = get-date
foreach ($file in $files) 
    {
        $razn = $now - $file.CreationTime
        if ($razn.Days -gt $days) {Remove-Item $file}
    }
    
