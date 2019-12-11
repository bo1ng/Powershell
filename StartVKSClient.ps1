$i=1

$u=1
$port=8078
$vport=10078
for ($i = 0; $i -lt 2; $i++)
{
    Start-Process "C:\Program Files (x86)\VKSClient\vks-client.exe" -ArgumentList "--user-name user$u --auth-user user$u --password user$u --domain demos.incoma.ru --one-copy-app 0 --confirm-close 0 --auto-discovered-enabled 0 --auto-accept-calls 1 --audio-device-output 0 --audio-device-input 0 --port 5060 --audio-port $port --video-port $vport"
    #Start-Process -FilePath "notepad.exe" -ArgumentList "D:\samoletov maksim\test.txt"
    #cmd.exe /c 'start "" notepad.exe "D:\samoletov maksim\test.txt"'
    #cmd.exe /c 'start "" "C:\Program Files (x86)\VKSClient\vks-client.exe" --user-name user$u --auth-user user$u --password user$u --domain demos.incoma.ru --one-copy-app 0 --confirm-close 0 --auto-discovered-enabled 0 --auto-accept-calls 1 --audio-device-output 0 --audio-device-input 0 --port 5060 --audio-port $port --video-port $vport'
    $u++
    $port=$port+2
    $vport=$vport+2
}