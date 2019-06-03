function Set-NetworkAdapterOpaqueNetwork {
param(
    [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
    [VMware.VimAutomation.Types.NetworkAdapter]
    $NetworkAdapter,

    [Parameter(Mandatory = $true, Position = 2)]
    [string]
    $OpaqueNetworkName,

    [Parameter()]
    [switch]
    $Connected,

    [Parameter()]
    [switch]
    $StartConnected
)
process {
    $opaqueNetwork = Get-View -ViewType OpaqueNetwork | ? {$_.Name -eq $OpaqueNetworkName}
    if (-not $opaqueNetwork) {
        throw "'$OpaqueNetworkName' network not found."
    }

    $opaqueNetworkBacking = New-Object VMware.Vim.VirtualEthernetCardOpaqueNetworkBackingInfo
    $opaqueNetworkBacking.OpaqueNetworkId = $opaqueNetwork.Summary.OpaqueNetworkId
    $opaqueNetworkBacking.OpaqueNetworkType = $opaqueNetwork.Summary.OpaqueNetworkType

    $device = $NetworkAdapter.ExtensionData
    $device.Backing = $opaqueNetworkBacking

    if ($StartConnected) {
        $device.Connectable.StartConnected = $true
    }

    if ($Connected) {
        $device.Connectable.Connected = $true
    }
    
    $spec = New-Object VMware.Vim.VirtualDeviceConfigSpec
    $spec.Operation = [VMware.Vim.VirtualDeviceConfigSpecOperation]::edit
    $spec.Device = $device
    $configSpec = New-Object VMware.Vim.VirtualMachineConfigSpec
    $configSpec.DeviceChange = @($spec)
    $NetworkAdapter.Parent.ExtensionData.ReconfigVM($configSpec)

    # Output
    Get-NetworkAdapter -Id $NetworkAdapter.Id
    }
}

Set-PowerCLIConfiguration -DefaultVIServerMode Multiple -Confirm:$false

Connect-VIServer vcsa-01a -username administrator@vsphere.local -Password VMware1!
Connect-VIServer vcsa-01b -username administrator@vsphere.local -Password VMware1!


get-vm edge-01b | Get-NetworkAdapter -Name "Network adapter 2" | Set-NetworkAdapterOpaqueNetwork -OpaqueNetworkName siteb-edge-transport-overlay
get-vm edge-01b | Get-NetworkAdapter -Name "Network adapter 3" | Set-NetworkAdapterOpaqueNetwork -OpaqueNetworkName siteb-edge-transport-uplink1
get-vm edge-01b | Get-NetworkAdapter -Name "Network adapter 4" | Set-NetworkAdapterOpaqueNetwork -OpaqueNetworkName siteb-edge-transport-uplink2

get-vm edge-02b | Get-NetworkAdapter -Name "Network adapter 2" | Set-NetworkAdapterOpaqueNetwork -OpaqueNetworkName siteb-edge-transport-overlay
get-vm edge-02b | Get-NetworkAdapter -Name "Network adapter 3" | Set-NetworkAdapterOpaqueNetwork -OpaqueNetworkName siteb-edge-transport-uplink1
get-vm edge-02b | Get-NetworkAdapter -Name "Network adapter 4" | Set-NetworkAdapterOpaqueNetwork -OpaqueNetworkName siteb-edge-transport-uplink2

$spec = New-Object VMware.Vim.VirtualMachineConfigSpec
$spec.memoryReservationLockedToMax = $false

(Get-VM -name edge* ).ExtensionData.ReconfigVM_Task($spec)
get-vm -Name edge* | Get-VMResourceConfiguration | Set-VMResourceConfiguration -MemReservationGB 0


