#$path = Read-Host "������� ���� �� ������������ PassAlarm.msi (������ - C:\Scripts\msi)"
$defpath = Get-Content Path.txt
#$ip = Read-Host "������� ������� ip-����� �� (������ - 192.168.150.3)"
Write-Host "��������� PassAlarm.msi" -foregroundcolor "DarkCyan"
Start-Process -filepath "$defpath\msi\PassAlarm.msi" -ArgumentList "/norestart /q" -Wait

#Write-Host "��������� iis60rkt.exe. ���������� ������� ������ ��������� SelfSSL" -foregroundcolor "DarkCyan"
#Start-Process -filepath "$defpath\msi\iis60rkt.exe" -Wait

#Write-Host "��������� ����������� �� IP ������"
#cd "C:\Program Files (x86)\IIS Resources\SelfSSL"
#Start-Process -Filepath "selfssl" -ArgumentList "/T /N:CN=$ip /V:10000" -wait

Write-Host "��������� � ���������������� ���������. ���������� ��������� �������� ChangePassword.aspx �� ������ �� https" -ForegroundColor "DarkYellow"
Write-Host "������� ����� ������� ��� �����������..."
$x=$host.UI.RawUI.ReadKey("NoEcho, IncludeKeyDown")
