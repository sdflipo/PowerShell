#LABDC1 CONFIGURATION
Rename-Computer -NewName LABDC1
New-NetIPAddress -InterfaceIndex 4 -IPAddress 192.168.0.11 -PrefixLength 24
Set-DnsClientServerAddress -InterfaceIndex 4 -ServerAddresses 192.168.0.11,192.168.0.12
Disable-NetAdapterBinding -Name "Ethernet"  -ComponentID ms_tcpip6
Restart-Computer
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
Install-ADDSForest -DomainName "LABDOMAIN.com" -InstallDNS
New-ADOrganizationalUnit -Name "UserAccounts" -Path "DC=LABDOMAIN,DC=com"
#USE BULKACCOUNTCREATION SCRIPT TO CREATE USERS
Get-ADGroup "Domain Admins" | Add-ADGroupMember -Members Defillippo.DA