$defpath = Get-Content Path.txt
do {$IESpath = Read-Host "������� ���� �� ������������ WebSphere Eclipse Platform (������ - D:\Prereqs\IES\MSI)"
    if ((Test-Path "$IESpath\IBM WebSphere Eclipse Platform V3.3.msi") -match "false")
        {
        Write-host "� ���������� $path ����������� ������������ ���� IBM WebSphere Eclipse Platform V3.3.msi" -ForegroundColor "red"
        }
    }
until ((Test-Path "$IESpath\IBM WebSphere Eclipse Platform V3.3.msi") -match "true")
Set-Location $iespath
Write-Host "��������� ��������� WebSphere MQ Eclipse Platform" -ForegroundColor "DarkCyan"
Start-Process -FilePath "IBM WebSphere Eclipse Platform V3.3.msi" -ArgumentList "/PASSIVE" -Wait

do {$path = Read-Host "������� ���� �� msi-����� WebSphere MQ (������ - D:\MSI)"
    if ((Test-Path "$path\IBM WebSphere MQ.msi") -match "false")
        {
            Write-Host "� ���������� $path ����������� ������������ ���� IBM WebSphere MQ.msi" -ForegroundColor "red"
        }
    }
until ((Test-Path "$path\IBM WebSphere MQ.msi") -match "true")
Set-Location $path
Write-Host "��������� IBM WebSphere MQ 7.0" -ForegroundColor "DarkCyan"
Start-Process -FilePath "IBM WebSphere MQ.msi" -ArgumentList "/PASSIVE USEINI=$defpath\MQ\conf.ini" -Wait

cd "$defpath\MQ\WebSphere MQ 7.0.1.13 EnUs"
Write-Host "��������� ���������� WebSphere MQ 7.0.1.13" -ForegroundColor "DarkCyan"
Start-Process -FilePath "install.bat" -wait
Write-Host "��������� ���������� �� ������ 7.0.1.13 ���������. ������� ����� ������� ��� �����������..."

$x=$host.UI.RawUI.ReadKey("NoEcho, IncludeKeyDown")
