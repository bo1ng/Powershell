$name = $(Get-WmiObject Win32_Computersystem).name
netdom renamecomputer $name /newname:SVK-GATE /userD:administrator /passwordd:password /reboot:10
Write-Host "Êîìïüþòåð áóäåò ïåðåçàãðóæåí..."
