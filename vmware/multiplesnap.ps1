connect-viserver SEUVCENTER -User SEUUSER -Password SEUPASSWORD

$vmlist = Get-Content C:\temp\lista.txt
New-Snapshot -VM $vmlist -Name teste -Description teste.
