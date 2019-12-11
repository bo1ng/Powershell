$mask = Read-Host "Файлы с каким расширением будем считать?"
$Path = Read-Host "В какой директории?"
$key = 0
while ($key -ne "y" -and $key -ne "n"){
Write-Host "Считать файлы во вложенных папках (y/n)?"
$key = $Host.UI.RawUI.ReadKey("IncludeKeyDown").Character
$x = $Host.UI.RawUI.ReadKey("NoEcho, IncludeKeyDOwn")
if ($key -eq "y")
    {$s=Get-ChildItem $Path -Recurse}
    elseif ($key -eq "n") {$s=Get-ChildItem $Path}
        else {Write-Host "`nОтвет может быть только y(yes) или n(no)"} 
  }

$c=0
Write-Host "`nВыполняется поиск файлов..."
switch ($s) {
{$_ -like "*.$mask"} {$c++}
}
#способ foreach вместо switch-конструкции
#foreach ($sf in $s) {if ($sf.name -like "*.$mask") {$c++}}
msg.exe * "найдено $c $mask-файлов"
Write-Host "найдено $c $mask-файлов"
Write-Host "Нажмите любую клавишу чтобы выйти"
#$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")