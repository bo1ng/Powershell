$defpath = Get-Content Path.txt

cd "$defpath\SQL"
Write-Host "�������� ��� ������ SvkMessages, SvkCounters, SvkUtils" -foregroundcolor "DarkCyan"
Start-Process -Filepath 'SetupDb.bat' -wait
Write-Host "�������� ������� ��� ��� ������" -foregroundcolor "DarkCyan"
Start-Process -Filepath 'CreateJobs.bat' -wait

Write-Host "�������� ��� ������ � ������� ���������!" -foregroundcolor "DarkCyan"
Write-Host "������� ����� ������� ��� �����������..."
$x=$host.UI.RawUI.ReadKey("NoEcho, IncludeKeyDown")
