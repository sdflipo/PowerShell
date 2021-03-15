#LABCL1 CONFIGURATION (Run on VM)
Rename-Computer -NewName LABCL1
New-NetIPAddress -InterfaceIndex 14 -IPAddress 192.168.0.20 -PrefixLength 24
Set-DnsClientServerAddress -InterfaceIndex 14 -ServerAddresses 192.168.0.11,192.168.0.12
Disable-NetAdapterBinding -Name "Ethernet"  -ComponentID ms_tcpip6
Restart-Computer
Add-Computer -DomainName LABDOMAIN -Restart