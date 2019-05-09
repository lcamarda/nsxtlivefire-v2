
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false

Connect-VIServer vcsa-01a.corp.local -User Administrator@vsphere.local -Password VMware1!


 if ( -not (Get-VDSwitch -Name SiteA-vDS-02) ) {
 write-host "the VDS does not exist, I am going to create it"

$myDatacenter = Get-Datacenter -Name "Site-A"

#Get all hosts in your datacenter.
$vmHosts = $myDatacenter | Get-VMHost

#Create a new vSphere distributed switch.

$myVDSwitch = New-VDSwitch -Name "SiteA-vDS-02" -Location $myDatacenter -NumUplinkPorts 2

#The distributed switch is created with no port groups.

#Add the hosts in your datacenter to the distributed switch.
Add-VDSwitchVMHost -VDSwitch $myVDSwitch -VMHost $vmHosts

Get-VDSwitch -Name SiteA-vDS-02 | Set-VDSwitch -Mtu 1700

#Add vmnic3 and vmnic4 on host 1 to the vDS

$myVDSwitch = Get-VDSwitch -name SiteA-vDS-02

$vmHost = Get-VMHost -name esx-01a.corp.local

#Get a physical network adapter from the host.
$hostsPhysicalNic1 = $vmHost | Get-VMHostNetworkAdapter -Name "vmnic3"
$hostsPhysicalNic2 = $vmHost | Get-VMHostNetworkAdapter -Name "vmnic4"

#Add the physical and vmk network adapter to the distributed switch
Add-VDSwitchPhysicalNetworkAdapter -VMHostNetworkAdapter $hostsPhysicalNic1 -DistributedSwitch $myVDSwitch  -Confirm:$false
Add-VDSwitchPhysicalNetworkAdapter -VMHostNetworkAdapter $hostsPhysicalNic2 -DistributedSwitch $myVDSwitch  -Confirm:$false

#Add vmnic3 and vmnic4 on host 2 to the vDS

$myVDSwitch = Get-VDSwitch -name SiteA-vDS-02

$vmHost = Get-VMHost -name esx-02a.corp.local

#Get a physical network adapter from the host.
$hostsPhysicalNic1 = $vmHost | Get-VMHostNetworkAdapter -Name "vmnic3"
$hostsPhysicalNic2 = $vmHost | Get-VMHostNetworkAdapter -Name "vmnic4"

#Add the physical and vmk network adapter to the distributed switch
Add-VDSwitchPhysicalNetworkAdapter -VMHostNetworkAdapter $hostsPhysicalNic1 -DistributedSwitch $myVDSwitch  -Confirm:$false
Add-VDSwitchPhysicalNetworkAdapter -VMHostNetworkAdapter $hostsPhysicalNic2 -DistributedSwitch $myVDSwitch  -Confirm:$false


#Add vmnic3 and vmnic4 on host 3 to the vDS

$myVDSwitch = Get-VDSwitch -name SiteA-vDS-02

$vmHost = Get-VMHost -name esx-03a.corp.local

#Get a physical network adapter from the host.
$hostsPhysicalNic1 = $vmHost | Get-VMHostNetworkAdapter -Name "vmnic3"
$hostsPhysicalNic2 = $vmHost | Get-VMHostNetworkAdapter -Name "vmnic4"

#Add the physical network adapter to the distributed switch
Add-VDSwitchPhysicalNetworkAdapter -VMHostNetworkAdapter $hostsPhysicalNic1 -DistributedSwitch $myVDSwitch  -Confirm:$false
Add-VDSwitchPhysicalNetworkAdapter -VMHostNetworkAdapter $hostsPhysicalNic2 -DistributedSwitch $myVDSwitch  -Confirm:$false

#Add vmnic3 and vmnic4 on host 4 to the vDS

$myVDSwitch = Get-VDSwitch -name SiteA-vDS-02

$vmHost = Get-VMHost -name esx-04a.corp.local

#Get a physical network adapter from the host.
$hostsPhysicalNic1 = $vmHost | Get-VMHostNetworkAdapter -Name "vmnic3"
$hostsPhysicalNic2 = $vmHost | Get-VMHostNetworkAdapter -Name "vmnic4"


#Add the physical  network adapter to the distributed switch
Add-VDSwitchPhysicalNetworkAdapter -VMHostNetworkAdapter $hostsPhysicalNic1 -DistributedSwitch $myVDSwitch  -Confirm:$false
Add-VDSwitchPhysicalNetworkAdapter -VMHostNetworkAdapter $hostsPhysicalNic2 -DistributedSwitch $myVDSwitch  -Confirm:$false



$routedLink1 = New-VDPortGroup -Name trunk1  -VDSwitch $myVDSwitch -VlanTrunkRange 0-4000
$routedLink2 = New-VDPortGroup -Name trunk2  -VDSwitch $myVDSwitch -VlanTrunkRange 0-4000

#Set teaming policy for edge vDS

$routedLink1 | Get-VDUplinkTeamingPolicy | Set-VDUplinkTeamingPolicy -ActiveUplinkPort "dvUplink1" -UnusedUplinkPort "dvUplink2"
$routedLink2 | Get-VDUplinkTeamingPolicy | Set-VDUplinkTeamingPolicy -ActiveUplinkPort "dvUplink2" -UnusedUplinkPort "dvUplink1"



}

