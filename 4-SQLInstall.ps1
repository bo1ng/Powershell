do {$path = Read-Host "������� ���� �� setup.exe ������������ SQL Server 2008 R2 (�������� D:\)"
    if ((Test-Path "$path\setup.exe") -match "false")
        {
        Write-host "� ���������� $path ����������� ������������ ���� setup.exe" -ForegroundColor "red"
        }
    }
until ((Test-Path "$path\setup.exe") -match "true")
$defpath = Get-Content Path.txt
Write-Host "��������� SQL Server 2008 R2" -Foregroundcolor "DarkCyan"
Start-Process -Filepath "$path\setup.exe" -ArgumentList "/Q /ACTION=install /IACCEPTSQLSERVERLICENSETERMS /SAPWD=Qaz123!@#wsx /CONFIGURATIONFILE=$defpath\SQL\configurationfile.ini /INDICATEPROGRESS" -Wait
Write-Host "��������� SP3" -Foregroundcolor "DarkCyan"
Start-Process -Filepath "$defpath\SQL\SQLServer2008R2SP3-KB2979597-x64-ENU.exe" -ArgumentList "/QS /ALLINSTANCES /ACTION=Patch /IACCEPTSQLSERVERLICENSETERMS /INDICATEPROGRESS" -Wait
#Write-Host "��������� ����������" -Foregroundcolor "DarkCyan"
#Start-Process -Filepath "$defpath\SQL\SQLServer2008R2-KB2754552-x64.exe" -ArgumentList "/Q /ACTION=Patch /IACCEPTSQLSERVERLICENSETERMS /instancename=SVK-GATE /INDICATEPROGRESS" -Wait
Write-Host "��������� ���������.��� ����������� ������� ����� �������..."
$x=$host.UI.RawUI.ReadKey("NoEcho, IncludeKeyDown")
