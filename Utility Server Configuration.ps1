#LABSVR1 CONFIGURATION (Run on VM)
Rename-Computer -NewName LABSVR1
New-NetIPAddress -InterfaceIndex 4 -IPAddress 192.168.0.12 -PrefixLength 24
Set-DnsClientServerAddress -InterfaceIndex 4 -ServerAddresses 192.168.0.11,192.168.0.12
Disable-NetAdapterBinding -Name "Ethernet"  -ComponentID ms_tcpip6
Restart-Computer
Add-Computer -DomainName LABDOMAIN -Restart
#CREATE SMB SHARE (MANUALLY ADD NEW DISK)
diskpart.exe
    List disk
    select disk 1
    attributes disk clear readonly
    convert mbr
    online disk
    convert dynamic
    create volume simple
    list volume
    select volume
    assign letter=s
    format volume
New-SmbShare -Path S:\ -Name Shares -FullAccess "LABDOMAIN\Domain Users"
#INSTALL AND CONFIGURE DHCP
Install-WindowsFeature DHCP -IncludeManagementTools
Add-DhcpServerv4Scope -Name "Client Workstations" -StartRange 192.168.0.130 -EndRange 192.168.0.254 -Subnetmask 255.255.255.0 -State Active
#ON LABDC1 INSTALL RSAT-DHCP FEATURE   
Add-DhcpServerInDC -DnsName LABSVR1.LABDOMAIN.com -IPAddress 192.168.0.12
#iSCSI (MANUALLY ADD DRIVE) USED GUI
#Install-WindowsFeature FS-iSCSITarget-Server -IncludeManagementTools
#diskpart.exe
#    List disk
#    select disk 2
#    attributes disk clear readonly
#    convert mbr
#    online disk
#    convert dynamic
#    create volume simple
#    list volume
#    select volume
#    assign letter=s
#    format volume
#CREATE A CHILD DOMAIN
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
Install-ADDSDomain -NewDomainName LABCHILD -ParentDomainName LABDOMAIN.com -DomainType ChildDomain -InstallDns -CreateDnsDelegation -ReplicationSourceDC LABDC1.LABDOMAIN.com -NoRebootOnCompletion -Credential (Get-Credential LABDOMAIN\administrator)