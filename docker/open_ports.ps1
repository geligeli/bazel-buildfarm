wsl.exe genie -i
$remoteport = bash.exe -c "ifconfig eth0 | grep 'inet '"
$found = $remoteport -match '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}';

if( $found ){
  $remoteport = $matches[0];
} else{
  echo "The Script Exited, the ip address of WSL 2 cannot be found";
  exit;
}

#[Ports]

#All the ports you want to forward separated by coma
#$tcp_ports=@(2377,7946,8980,8981);
#$udp_ports=@(4789,7946);
$tcp_ports=@(8980,8981);
$udp_ports=@();


#[Static ip]
#You can change the addr to your ip config to listen to a specific address
$addr='0.0.0.0';
$tcp_ports_a = $tcp_ports -join ",";
$udp_ports_a = $udp_ports -join ",";


#Remove Firewall Exception Rules
iex "Remove-NetFireWallRule -DisplayName 'WSL 2 Firewall Unlock' ";

#adding Exception Rules for inbound and outbound Rules
iex "New-NetFireWallRule -DisplayName 'WSL 2 Firewall Unlock' -Direction Outbound -LocalPort $tcp_ports_a -Action Allow -Protocol TCP";
iex "New-NetFireWallRule -DisplayName 'WSL 2 Firewall Unlock' -Direction Inbound -LocalPort $tcp_ports_a -Action Allow -Protocol TCP";

if( $udp_ports.length > 0 ){
  echo "Adding UDP Firewall rules"
  iex "New-NetFireWallRule -DisplayName 'WSL 2 Firewall Unlock' -Direction Outbound -LocalPort $udp_ports_a -Action Allow -Protocol UDP";
  iex "New-NetFireWallRule -DisplayName 'WSL 2 Firewall Unlock' -Direction Inbound -LocalPort $udp_ports_a -Action Allow -Protocol UDP";
}

echo "Forwarding ports for tcp"
for( $i = 0; $i -lt $tcp_ports.length; $i++ ){
  $port = $tcp_ports[$i];
  iex "netsh interface portproxy delete v4tov4 listenport=$port listenaddress=$addr";
  iex "netsh interface portproxy add v4tov4 listenport=$port listenaddress=$addr connectport=$port connectaddress=$remoteport";
}
echo "Killing all sudppipe.exe"
taskkill /IM "sudppipe.exe" /F
echo "Forwarding ports for udp"
for( $i = 0; $i -lt $udp_ports.length; $i++ ){
  $port = $udp_ports[$i];
  Start-Process .\sudppipe.exe -WindowStyle Hidden -ArgumentList "-x $remoteport $port $port";
}