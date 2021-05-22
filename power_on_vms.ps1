connect-viserver VCENTER -User login -Password senha

foreach($lista in (Get-Content -Path C:\temp\lista.txt)){
$vm = Get-VM -Name $lista
Start-VM -VM $vm -Confirm:$false
}
