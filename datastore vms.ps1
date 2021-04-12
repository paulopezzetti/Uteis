$outputFile = "C:\temp\output.csv" 

$VMsAdv = Get-VM | Sort-Object Name | % { Get-View $_.ID } 
$myCol = @() 
ForEach ($VMAdv in $VMsAdv) 
{ 
    ForEach ($Disk in $VMAdv.Layout.Disk) 
    { 
        $myObj = "" | Select-Object Name, Disk 
        $myObj.Name = $VMAdv.Name 
        $myObj.Disk = $Disk.DiskFile[0] 
        $myCol += $myObj 
    } 
} 
$myCol | Export-Csv $outputFile -NoTypeInformation
