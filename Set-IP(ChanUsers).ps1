$users = Get-ADUser -filter * | Where-Object {$_.name -like "c7??"}
Foreach ($user in $users) 
{
    $username = $user.name
    $endip = $username.substring(2)
    Set-ADUser $user -office "172.26.128.1$endip"
} 


$users = Get-ADUser -filter * | Where-Object {$_.name -like "c7??test"}
Foreach ($user in $users) 
{
    $username = $user.name
    $endip = $username.substring(2,2)
    Set-ADUser $user -office "172.26.128.1$endip"
}


$users = Get-ADUser -filter * | Where-Object {$_.name -like "c7??u"}
Foreach ($user in $users) 
{
    $username = $user.name
    $endip = $username.substring(2,2)
    Set-ADUser $user -office "172.26.125.1$endip"
}         