import-module ActiveDirectory
$users = Get-ADuser -filter * -SearchBase "OU=Клиенты Банка России, DC=svk, DC=stavropol, DC=cbr, DC=ru"
$userslist = $users | select userprincipalname
Write-Host "Изменения будут внесены для следующих пользователей" -foregroundcolor "green"
$userslist
$userslist | Out-File "C:\userslist.txt"
Write-Host "Список пользователей сохранен в файле C:\userslist.txt" -foregroundcolor "green"
Write-Host "Нажмите любую клавишу для внесения изменений в настройки учетных записей или закройте консоль для отмены..." -foregroundcolor "green"
$x=$host.UI.RawUI.Readkey("NoEcho, IncludeKeyDown")
foreach ($user in $users)
{
Set-AdAccountControl $user -CannotChangePassword $true
}
Write-Host "Изменения внесены" -foregroundcolor "green"
Write-Host "Нажмите любую клавишу для продолжения..."
$x=$host.UI.RawUI.Readkey("NoEcho, IncludeKeyDown")