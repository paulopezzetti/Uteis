Get-ADGroup -Server dc1.adm-cesumar.local -Filter * | Select @{N=”sql”;E={$_.Name}} | Export-csv c:\GuposAD.csv
