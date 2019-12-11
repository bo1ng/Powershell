$Length = 0
function FilesSum ($files){
foreach ($file in $files){$Length = $length + $file.Length/1mb}
return $Length
}
$folders = Get-ChildItem "D:\Games\"

foreach ($folder in $folders) {$folderLength = FilesSum (Get-ChildItem "$folder" -Recurse);Write-Host "$folder -- $folderLength MB"}

