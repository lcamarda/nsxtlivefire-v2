Connect-VIServer vcsa-01a.corp.local -User Administrator@vsphere.local -Password VMware1! | out-null
$spec = New-Object VMware.Vim.VirtualMachineConfigSpec
$spec.memoryReservationLockedToMax = $false

(Get-VM -name edge* ).ExtensionData.ReconfigVM_Task($spec)
get-vm -Name edge* | Get-VMResourceConfiguration | Set-VMResourceConfiguration -MemReservationGB 0
