#INSTALL HOST OS FROM BOOTABLE USB
#HOST CONFIGURATION
Rename-Computer LABHOST
New-NetIPAddress -InterfaceIndex 17 -IPAddress 192.168.0.10 -PrefixLength 24
Set-DnsClientServerAddress -InterfaceIndex 17 -ServerAddresses 192.168.0.11,192.168.0.12
Disable-NetAdapterBinding -Name "vEthernet (LABVSWITCH)"  -ComponentID ms_tcpip6
Install-WindowsFeature HyperV -IncludeManagementTools -IncludeAllSubFeature
New-VMSwitch -Name LABVSWITCH -SwitchType Internal
Restart-Computer

#CREATE VMs
New-VM -Name LABDC1 -MemoryStartupBytes 4096MB -Generation 2 -NewVHDSizeBytes 50GB -NewVHDPath 'C:\Users\Public\Documents\Hyper-V\Virtual hard disks\LABDC1.vhdx' -SwitchName LABVSWITCH 
New-VM -Name LABSVR1 -MemoryStartupBytes 4096MB -Generation 2 -NewVHDSizeBytes 50GB -NewVHDPath 'C:\Users\Public\Documents\Hyper-V\Virtual hard disks\LABSVR1.vhdx' -SwitchName LABVSWITCH
New-VM -Name LABCL1 -MemoryStartupBytes 4096MB -Generation 2 -NewVHDSizeBytes 50GB -NewVHDPath 'C:\Users\Public\Documents\Hyper-V\Virtual hard disks\LABCL1.vhdx' -SwitchName LABVSWITCH

#START VMs
Start-VM LABDC1,LABSVR1,LABCL1

#MOUNT CD DRIVE
Add-VMDvdDrive -VMName LABDC1,LABSVR1 -Path 'C:\Users\Public\Desktop\Windows_Server_2016_Datacenter_EVAL_en-us_14393_refresh.ISO'
Add-VMDvdDrive -VMName LABCL1 -Path 'C:\Users\Public\Desktop\Windows.ISO'

#INSTALL OS MANUALLY ON EACH VM

#REMOVE MOUNTED CD DRIVE
Remove-VMDvdDrive -VMName LABCL1 -ControllerNumber 0 -ControllerLocation 1
Remove-VMDvdDrive -VMName LABDC1 -ControllerNumber 0 -ControllerLocation 1
Remove-VMDvdDrive -VMName LABSVR1 -ControllerNumber 0 -ControllerLocation 1