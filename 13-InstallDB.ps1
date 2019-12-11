$defpath = Get-Content Path.txt

cd "$defpath\SQL"
Write-Host "Создание баз данных SvkMessages, SvkCounters, SvkUtils" -foregroundcolor "DarkCyan"
Start-Process -Filepath 'SetupDb.bat' -wait
Write-Host "Создание заданий для баз данных" -foregroundcolor "DarkCyan"
Start-Process -Filepath 'CreateJobs.bat' -wait

Write-Host "Создание баз данных и заданий завершено!" -foregroundcolor "DarkCyan"
Write-Host "Нажмите любую клавишу для продолжения..."
$x=$host.UI.RawUI.ReadKey("NoEcho, IncludeKeyDown")
