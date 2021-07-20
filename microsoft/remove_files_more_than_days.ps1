
function DelOldFile

{
param($Directory,$Date)

$Date = (get-date) - (new-timespan -day 15)  # Numero de dias que os arquivos foram criados

$Directory = "C:\Temp"  # Local dos arquivos a serem deletados

Get-ChildItem $Directory -Recurse | where {$_.LastWriteTime -le $Date}

Get-ChildItem $Directory -Recurse | where {$_.LastWriteTime -le $Date} | del

}

DelOldFile
