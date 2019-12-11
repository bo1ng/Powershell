import-module ActiveDirectory
$users = Get-ADuser -filter * -SearchBase "OU=������� ����� ������, DC=svk, DC=stavropol, DC=cbr, DC=ru"
$userslist = $users | select userprincipalname
Write-Host "��������� ����� ������� ��� ��������� �������������" -foregroundcolor "green"
$userslist
$userslist | Out-File "C:\userslist.txt"
Write-Host "������ ������������� �������� � ����� C:\userslist.txt" -foregroundcolor "green"
Write-Host "������� ����� ������� ��� �������� ��������� � ��������� ������� ������� ��� �������� ������� ��� ������..." -foregroundcolor "green"
$x=$host.UI.RawUI.Readkey("NoEcho, IncludeKeyDown")
foreach ($user in $users)
{
Set-AdAccountControl $user -CannotChangePassword $true
}
Write-Host "��������� �������" -foregroundcolor "green"
Write-Host "������� ����� ������� ��� �����������..."
$x=$host.UI.RawUI.Readkey("NoEcho, IncludeKeyDown")