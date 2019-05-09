Connect-VIServer vcsa-01a.corp.local -User Administrator@vsphere.local -Password VMware1! | out-null
$PG = Get-VDPortgroup -name trunk1
return $PG.key
