param (
    [string]$VMHost = $(throw "Please specify VMHost"),
    [switch]$create,
    [switch]$remove,
    [string]$VMs,
    [string]$resourcepool
)

# Set some variables
$Date = (Get-Date).ToString(“yyyyMMdd”)
$username = [Environment]::UserName

# Add PowerCLI cmdlets.
Add-PSSnapin VMware.VimAutomation.Core 

#Connect to vCenter
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore
Connect-VIServer -Server $VMHost

# Get list of VMs
if ($VMs) {
    $guests = $VMs | Get-VM
   }
elseif (( $resourcepool) -and !($VMs)) {
    $guests = get-resourcepool $resourcepool | Get-VM | where { $_.PowerState -eq "PoweredOn" }
}
else { "No VMs were provided/found" }

# Create/Remove/Cancel
if (( $create ) -and !( $remove )) {
    foreach ($guest in $guests) {
        new-snapshot -VM $guest -name $Date -Description "created by $username on $Date"
    }
}
elseif (( $remove ) -and !( $create )) {
    foreach ($guest in $guests ) {
        $guest | get-snapshot -name "created by $username on $Date" | Remove-Snapshot -whatif
    }
}
else { "You need to specify -create or -remove, but not both" }