connect-viserver SEUVCENTER -User SEUUSER -Password SEUPASSWORD

$maxtasks = 5
 
$snaps = Get-VM | Get-Snapshot | Where { $_.Description -like "DESCRIÇÃO" }
 
$i = 0
while($i -lt $snaps.Count) {
	Remove-Snapshot -Snapshot $snaps[$i] -RunAsync -Confirm:$false
	$tasks = Get-Task -Status "Running" | where {$_.Name -eq "RemoveSnapshot_Task"}
	while($tasks.Count -gt ($maxtasks-1)) {
		sleep 30
		$tasks = Get-Task -Status "Running" | where {$_.Name -eq "RemoveSnapshot_Task"}
     }
     $i++
}
