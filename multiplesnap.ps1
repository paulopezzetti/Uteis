connect-viserver SEUVCENTER

$VMs = Get-VM NOMEDAVM1, NOMEDAVM2

New-Snapshot -VM $VMs -Name NOMEDOSNAPSHOT -Description DESCRICAODOSNAPSHOT