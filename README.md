maintenance_snapshots
=====================

Use VMware Power CLI to create snapshots quickly before maintenance starts

Parameters
----------

* VMHost - (Required) specify the physical host, esx/esxi/vcenter server
* create - use this switch to indicate creation of snapshots
* remove - use this switch to indicate the removal of snapshots
* VMs - using comma seperater specify list of vm's to snapshot
* resourcepool -  specify a resource pool, if you don't want to list out the vm's

Examples
--------

Create a snapshot of node0, node1, and node2
```
.\maintenance_snapshots.ps1 -VMHost vcenter1.domain.local -create -vms node0,node1,node2
```

Create a snapshot of all hosts in the resource pool Production
```
.\maintenance_snapshots.ps1 -VMHost vcenter1.domain.local -create -resourcepool Production
```

Remove a snapshot of node0 and node2
```
.\maintenance_snapshots.ps1 -VMHost vcenter1.domain.local -remove -vms node0,node2
```

Requirements
------------

* One must have PowerShell
* One must have VMWare Power CLI installed

Notes
-----
* Snapshots will be created with the following name: `pre-maintenance $Date`
* Snapshots will be created with the following description: `created by $username using $scriptname on $Date_$Time`
* Snapshots will only removed that were created with the specific name and current date for the host or resource pool specified
