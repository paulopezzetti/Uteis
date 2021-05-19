$outFile = "C:\temp\hostname.txt"

Get-Content C:\temp\IP_Address.txt | ForEach-Object {
    $hash = @{ IPAddress = $_
        hostname = "n/a"     
    }
    $hash.hostname = ([system.net.dns]::GetHostByAddress($_)).hostname
    $object = New-Object psobject -Property $hash
    Export-CSV -InputObject $object -Path $outFile -Append -NoTypeInformation
}
