﻿$pwd = ConvertTo-SecureString "Qaz123!@#wsx" -AsPlainText -Force
#$cred = New-Object System.Management.Automation.PsCredential ("Administrator", $pwd)
Function PSSession ([string]$pcname)
{ 
    $session =  New-PSSession -ComputerName $pcname -credential "incoma\aleksandr vyushin"
    Invoke-Command -Session $session -ScriptBlock {<#Здесь команда, которую нужно выполнить на сервере#>}
    Remove-PSSession -Session $session
} 

PSSession ("m-oc0903")
PSSession ("m-oc0904")
PSSession ("m-oc0905")
PSSession ("m-oc0906")
PSSession ("m-oc0907")
PSSession ("m-oc0908")
PSSession ("m-oc0909")
PSSession ("m-oc0910")
PSSession ("m-oc0911")
PSSession ("m-oc0899")