param (
    [string]$VMHost = $(throw "Please specify VMHost"),
    [switch]$create,
    [switch]$remove,
    [array]$VMs,
    [string]$resourcepool
)

# Set some variables
$Date = (Get-Date).ToString(“yyyyMMdd”)
$Time = (Get-Date).ToString("HHmm")
$username = [Environment]::UserName
$scriptname = [Environment]::GetCommandLineArgs()[0]

# Add PowerCLI cmdlets.
Add-PSSnapin VMware.VimAutomation.Core 

# Connect to vCenter
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore
Connect-VIServer -Server $VMHost

# Get list of VMs
if ($VMs) {
    foreach ( $i in $VMs) {
        $guests += @(Get-VM -Name $i)
    }
}
elseif (( $resourcepool) -and !($VMs)) {
    $guests = get-resourcepool $resourcepool | Get-VM | where { $_.PowerState -eq "PoweredOn" }
}
else { "No VMs were provided/found" }

# Create/Remove/Cancel
if (( $create ) -and !( $remove )) {
    foreach ($guest in $guests) {
        new-snapshot -VM $guest -name "pre-maintenance $Date" -Description "created by $username using $scriptname on $Date_$Time"
    }
}
elseif (( $remove ) -and !( $create )) {
    foreach ($guest in $guests ) {
        $guest | get-snapshot -name "pre-maintenance $Date" | Remove-Snapshot
    }
}
else { "You need to specify -create or -remove, but not both" }