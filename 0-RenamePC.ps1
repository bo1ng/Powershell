$name = $(Get-WmiObject Win32_Computersystem).name
netdom renamecomputer $name /newname:SVK-GATE /userD:administrator /passwordd:Qaz123!@#wsx /reboot:10
Write-Host "Компьютер будет перезагружен..."
