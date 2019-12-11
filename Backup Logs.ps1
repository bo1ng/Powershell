<# 
   .Synopsis 
    This script archives the Event logs 
   .Description 
    This script can be run periodically (or regularly) to Archive or Backup event logs 
    NB, this script backs them up and deletes them, so its not just a backup. 
    The Script is designed to save Security logs for Auditing purposes. 
    Due to the fact that this copies the logs into memory, then deletes the logs,  
    then archives them to CSV, I recommend running this locally or via PS Remoting. 
   .Example 
    .\Start-BackupEventLogs.ps1 
   .Inputs 
    N/A 
   .OutPuts 
    N/A 
   .Notes 
    NAME: Start-BackupEventLogs.ps1 
    AUTHOR: Benjamin R Wilkinson 
    HANDCODED: Using Windows PowerShell ISE. 
    VERSION: 1.0.0 
    LASTEDIT: 07/20/2010 
    KEYWORDS:  
   .Link 
#> 
#Requires -Version 2.0 
[CmdletBinding()] 
 Param  
   ( 
    [Parameter(Mandatory=$false, 
               ValueFromPipeline=$true, 
               ValueFromPipelineByPropertyName=$true)] 
    [String] 
    $computer = "$ENV:COMPUTERNAME",             
    [ValidateSet("Application", "Security", "System")] 
    [Alias("l","log")] 
    [String] 
    $LogName = "Security", 
    #$MinBackupSize = "209715200", # 200MB 
    $MinBackupSize = "204472320", # 195MB 
    #$MinBackupSize = "20971520", # 20MB 
    [String]$BackupLocal = "C:\LOGSBackup", 
    #[String]$Backupremote = "C:\LogBackups" 
    #[String]$Backupremote = "\\ADTEST04\logs\seclogs" 
    [String]$Backupremote = "\\serverfs01\logs\seclogs" 
   )#End Param 
Begin 
{ 
 # The write-zip cmdlet is from the PowerShell community extensions. http://pscx.codeplex.com/ 
 Import-Module PSCX 
 Write-Host "Processing $Logname Logs .. .. Server:"$computer (get-date) 
} 
Process 
{ 
    $BaseDirLocal = "$BackupLocal\{0:yyyy_MM}-Logs" -f [DateTime]::now 
    $LogFileName = "{0}-{1:yyyyMMdd_HHmm}-{2}.csv" -f $Computer,[DateTime]::now,$LogName 
    $PathLocal = Join-Path -Path $BaseDirLocal -ChildPath $LogFileName 
    Write-Host "  + Processing $LogName Log" 
    Write-Host "    - Reading $LogName Log" 
     
    $Query = "Select * from Win32_NTEventLogFile where LogfileName = '$LogName'" 
    if ((Get-WmiObject -Query $Query -ComputerName "localhost").FileSize -gt $MinBackupSize) 
       { 
        #Save the logs from the Event Logs to PSObject/Memory 
        $SecLogs = get-eventlog -LogName $LogName 
         
        #Clear the event logs 
        Write-Host "    - Clearing $LogName Log" 
        Clear-EventLog -LogName $LogName 
         
        # Make sure the local directory exists 
        If(!(Test-Path $BaseDirLocal)) 
        { 
          New-Item $BaseDirLocal -type Directory -force | out-Null 
        } 
        Write-Host "    - Writing to CSV" 
         
        # Export from PSObject/Memory to CSV  
        $SecLogs | ForEach-Object {$RString = $_.ReplacementStrings | ForEach-Object {$_} 
        $Hash = @{              
        EventID       =$_.EventID 
        MachineName   =$_.MachineName 
        Category      =$_.Category 
        CategoryNumber=$_.CategoryNumber 
        EntryType     =$_.EntryType 
        ReplStrings   ="$RString" 
        TimeGenerated =$_.TimeGenerated 
        UserName      =$_.UserName} 
        New-Object PSObject -Property $Hash 
        } | Export-Csv -Path $PathLocal -NoTypeInformation 
        Write-Host "    - Writing to CSV complete" 
         
        # Zip up the Logs/CSV File 
        Write-Host "    - Converting to Zip" 
        $ZipLogArchiveFile = Get-ChildItem $PathLocal | write-zip -level 9 
        if (Test-Path -Path $ZipLogArchiveFile) 
        { 
         Remove-Item -Path $PathLocal 
        } 
         
        # Copy the Logs/CSV up to the fileshare 
        $BaseDirRemote = "$Backupremote\{0:yyyy_MM}-Logs" -f [DateTime]::now 
        If(!(Test-Path -Path $BaseDirRemote)) 
        { 
          New-Item $BaseDirRemote -type Directory -force | out-Null 
        } 
         
        # Remove the Old File 
        If(Test-Path -Path $BaseDirLocal) 
        { 
          # Move all files from the local directory, then delete the directory 
          Write-Host "    - Archiving Zip file:"$ZipLogArchiveFile.Name 
          Move-Item "$BaseDirLocal\*.zip" -Destination $BaseDirRemote -Force 
          Remove-Item -Path $BaseDirLocal 
        } 
       } 
    else 
       { 
        $Skip = $True 
       }     
} 
End 
{ 
 if (!$Skip) 
    { 
     $Msg = "Processing $LogName log now complete, there were {0} logs exported." -f $SecLogs.count 
     $Msg2 = "Logs were saved to {0}\{1}" -f $BaseDirRemote, $ZipLogArchiveFile.Name 
     Write-Host $Msg 
     Write-Host $Msg2 
     (get-date) 
    } 
 else 
    { 
     Write-Host "Logs file size less than $($MinBackupSize/1MB) MB, no changes made"  
    } 
$Skip = $Null 
}