$array=@()
$computer=Get-Content -Path CAMINHODALISTA
ForEach ($server in $computer) {
    if (Test-Connection $server -Quiet -count 1) {
        try {
            $IP = ([System.net.dns]::GetHostEntry($server).AddressList | ForEach-Object {$_.IPAddressToString} ) -join ";"
        }
        catch {"Invalid HostName" - $server}
    }
    else {
        $IP="Invalid Host"
    }
    $obj = New-Object PSObject -Property @{
        Hostname = $server
        IP = $IP
    }
    $array += $obj
}

$array | Export-Csv -NoTypeInformation CAMINHODESAIDA
