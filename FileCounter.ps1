$mask = Read-Host "����� � ����� ����������� ����� �������?"
$Path = Read-Host "� ����� ����������?"
$key = 0
while ($key -ne "y" -and $key -ne "n"){
Write-Host "������� ����� �� ��������� ������ (y/n)?"
$key = $Host.UI.RawUI.ReadKey("IncludeKeyDown").Character
$x = $Host.UI.RawUI.ReadKey("NoEcho, IncludeKeyDOwn")
if ($key -eq "y")
    {$s=Get-ChildItem $Path -Recurse}
    elseif ($key -eq "n") {$s=Get-ChildItem $Path}
        else {Write-Host "`n����� ����� ���� ������ y(yes) ��� n(no)"} 
  }

$c=0
Write-Host "`n����������� ����� ������..."
switch ($s) {
{$_ -like "*.$mask"} {$c++}
}
#������ foreach ������ switch-�����������
#foreach ($sf in $s) {if ($sf.name -like "*.$mask") {$c++}}
msg.exe * "������� $c $mask-������"
Write-Host "������� $c $mask-������"
Write-Host "������� ����� ������� ����� �����"
#$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")