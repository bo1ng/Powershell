$region = Read-Host "Введите имя региона ЗАГЛАВНЫМИ БУКВАМИ"
$defpath = Get-Content Path.txt

Write-Host "Установка CBR.Gateway.msi" -foregroundcolor "DarkCyan"
Start-Process -filepath "$defpath\msi\CBR.Gateway.msi" -ArgumentList "/norestart /q" -Wait

Write-Host "Регистрация схемы свойств адаптера" -foregroundcolor "DarkCyan"
cd "C:\Program Files\ACS\CBR.Gateway\Setup"
$content = Get-Content bindings.xml
$content = $content -replace "vlgrad","$region"
Set-Content bindings.xml -Value $content
Start-Process -FilePath "Deploy.bat" -Wait

Write-Host "Настройка доступа к каталогу Config" -foregroundcolor "DarkCyan"
cd "$defpath\SetAcl\"
Start-Process -FilePath "SetSvkAccessRights.bat" -Wait

Write-Host "Настройка аудита для gateway.config" -foregroundcolor "DarkCyan"
$Target = "C:\Program Files\ACS\Cbr.Gateway\Config\gateway.config"
$AuditUser = "Everyone"
$AuditRules = "Delete,ChangePermissions,Takeownership,CreateFiles,AppendData"
$InheritType = "ContainerInherit,ObjectInherit"
$AuditType = "Success, Failure"
$ACL = new-object System.Security.AccessControl.DirectorySecurity
$AccessRule = New-Object System.Security.AccessControl.FileSystemAuditRule($AuditUser,$AuditRules,$InheritType,"None",$AuditType)
$ACL.SetAuditRule($AccessRule)
$ACL | Set-Acl $Target

Write-Host "Регистрация источников событий" -foregroundcolor "DarkCyan"
cd "$defpath\RegisterEventSource\"
Start-Process -Filepath "RegisterSVK.bat" -Wait

Write-Host "Установка канальной программы выхода" -foregroundcolor "DarkCyan"
cd "$defpath\WMQexit\"
Start-Process -Filepath "install_wmq_exit.bat" -Wait

Write-Host "СПО Транспортный шлюз установлено и сконфигурировано" -foregroundcolor "DarkCyan"
Write-Host "Нажмите любую клавишу для продолжения..."
$x=$host.UI.RawUI.ReadKey("NoEcho, IncludeKeyDown")
