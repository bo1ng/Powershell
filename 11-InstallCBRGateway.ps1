$region = Read-Host "������� ��� ������� ���������� �������"
$defpath = Get-Content Path.txt

Write-Host "��������� CBR.Gateway.msi" -foregroundcolor "DarkCyan"
Start-Process -filepath "$defpath\msi\CBR.Gateway.msi" -ArgumentList "/norestart /q" -Wait

Write-Host "����������� ����� ������� ��������" -foregroundcolor "DarkCyan"
cd "C:\Program Files\ACS\CBR.Gateway\Setup"
$content = Get-Content bindings.xml
$content = $content -replace "vlgrad","$region"
Set-Content bindings.xml -Value $content
Start-Process -FilePath "Deploy.bat" -Wait

Write-Host "��������� ������� � �������� Config" -foregroundcolor "DarkCyan"
cd "$defpath\SetAcl\"
Start-Process -FilePath "SetSvkAccessRights.bat" -Wait

Write-Host "��������� ������ ��� gateway.config" -foregroundcolor "DarkCyan"
$Target = "C:\Program Files\ACS\Cbr.Gateway\Config\gateway.config"
$AuditUser = "Everyone"
$AuditRules = "Delete,ChangePermissions,Takeownership,CreateFiles,AppendData"
$InheritType = "ContainerInherit,ObjectInherit"
$AuditType = "Success, Failure"
$ACL = new-object System.Security.AccessControl.DirectorySecurity
$AccessRule = New-Object System.Security.AccessControl.FileSystemAuditRule($AuditUser,$AuditRules,$InheritType,"None",$AuditType)
$ACL.SetAuditRule($AccessRule)
$ACL | Set-Acl $Target

Write-Host "����������� ���������� �������" -foregroundcolor "DarkCyan"
cd "$defpath\RegisterEventSource\"
Start-Process -Filepath "RegisterSVK.bat" -Wait

Write-Host "��������� ��������� ��������� ������" -foregroundcolor "DarkCyan"
cd "$defpath\WMQexit\"
Start-Process -Filepath "install_wmq_exit.bat" -Wait

Write-Host "��� ������������ ���� ����������� � ����������������" -foregroundcolor "DarkCyan"
Write-Host "������� ����� ������� ��� �����������..."
$x=$host.UI.RawUI.ReadKey("NoEcho, IncludeKeyDown")
