#Задаем константы
Set-Location "C:\WINDOWS\system32\config"
$Dest = "C:\LOGFILES\EVENTLOG"
$AppDest = "C:\LOGFILES\EVENTLOG\Application\"
$SecDest = "C:\LOGFILES\EVENTLOG\Security\"

#Задаем общие блоки фунций

Function Text { 
			  Out-File -filepath  $Dest\logs.txt -Append -inputobject $args
			  }
Function Rename {
				Get-ChildItem *Application*.evt | ForEach-Object {
																  $Mess = " "+ $_ +" - will be renamed"; 
																  Text $Mess ;
																  Rename-Item -path $_ -NewName ('Application'+ " " + $_.LastWriteTime.tostring('dd-MM-yyyy (HH-mm-ss)')+'.evt')
																 }                                          
				Get-ChildItem *Security*.evt | ForEach-Object {
															   $Mess = " "+ $_ +" - will be renamed";
															   Text $Mess ;
															   Rename-Item -path $_ -NewName ('Security'+ " " + $_.LastWriteTime.tostring('dd-MM-yyyy (HH-mm-ss)')+'.evt')
															  }
				}
Function Moving {
				Get-ChildItem Application*.evt | ForEach-Object {                                                
																 $Mess = " "+ $_ + " - will be move in "+ $AppDest ; 
																 Text $Mess ;
																 Move-Item $_ -destination $AppDest 
																}
				Get-ChildItem Security*.evt | ForEach-Object {
															  $Mess = " "+ $_ + " - will be move in "+ $SecDest ; 
															  Text $Mess ;
															  Move-Item $_ -destination $SecDest 
															 }
				}
Function Archive {
				  Set-Location $Dest
				  Get-ChildItem $AppDest\Application*.evt | ForEach-Object  {
																			if ($_.LastWriteTime -le $DateLastWriteTimeOld) {
																															$Mess =" "+ $_.name +" - file will be archive" ;
																															Text $Mess ;
																															.\PkZIP25.exe -add $_ +".zip" "'"+ $_ +"'"; 
																															Remove-Item -path $_ 
																															}
																			else                                            { 
																															$Mess =" "+ $_.name + " - This file is less then 2 days old" ;
																															Text $Mess ;
																															}
																			}
				  Get-ChildItem $SecDest\Security*.evt | ForEach-Object {
																		if ($_.LastWriteTime -le $DateLastWriteTimeOld) {
																														$Mess = " "+ $_.name + " - file will be archive" ;
																														Text $Mess ;
																														.\PkZIP25.exe -add $_ +".zip" "'"+ $_ +"'"; 
																														Remove-Item -path $_ 
																														}
					    												else                                            { 
																													    $Mess = " "+ $_.name + " - This file is less then 2 days old" ;
																													    Text $Mess ;
																													    }
																		} 
				 }
		
$DateLastWriteTimeOld = (get-date).AddDays(-0) 
#Задаем период после которого файлы надо сжимать. Сейчас стоит 0 дня.
$Today = get-date -UFormat "%d.%m.%Y %H-%M-%S" 
Text "------------------------------------------------------------------------
$Today
We are looking for the file older then $DateLastWriteTimeOld
"		
#Проверка на наличие файлов.Если нет файлов то сразу в конец кода.	
$Existing = Get-ChildItem *Application*.evt, *Security*.evt 			 
If ($Existing.count -gt 0) {
                            Text "YAHOO We have files to work with !"; 										   
							#Переименовываем файлы в нужный формат.
							Rename
							#Переносим файлы по определенным папкам.
							Moving
							#Сравниваем файлы.Вычисляем которые старше чем X + архивируем их + удаляем исходники.Внимание Set-Location выставленные ниже только из-за глюков PkZIP25.exe
							Archive
                           }
else                       {
                            Text "There is no files to work with in system32\config";
							Text "Fing out if Application or Security files have already copyed";
							Text " "
							#Проверяем что с файлами которые уже лежат в папке для архивации
							Archive
                           }

						   
$Today = get-date -UFormat "%d.%m.%Y %H-%M-%S"
Text " "
Text "Work done in $Today"